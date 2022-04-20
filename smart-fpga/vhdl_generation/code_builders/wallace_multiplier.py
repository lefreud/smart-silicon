from typing import *
from code_builders.abstract_code_builder import AbstractCodeBuilder
from component_instances.abstract_component_instance import AbstractComponentInstance
from signals.vhdl_signal import Signal
from code_builders.wallace_stage import WallaceStage
from code_builders.partial_products import PartialProductsBuilder
from code_builders.ripple_carry_adder import RippleCarryAdder
import itertools


class WallaceMultiplier(AbstractCodeBuilder):
    def __init__(self, operands_size_bits):
        self.operands_size_bits = operands_size_bits
        self.stages = []
        self.partial_products_builder = None
        self.ripple_carry_adder = None

    def _get_first_stage(self, operands_size_bits):
        a_signal_list = [Signal(f"a({i})", 0) for i in range(operands_size_bits)]
        b_signal_list = [Signal(f"b({i})", 0) for i in range(operands_size_bits)]
        self.partial_products_builder = PartialProductsBuilder(a_signal_list, b_signal_list)
        self.partial_products_builder.build()
        partial_products = self.partial_products_builder.get_partial_products()

        input_signal_lists = [list() for _ in range(operands_size_bits * 2 - 1)]
        for i in range(operands_size_bits):
            for j in range(operands_size_bits):
                input_signal_lists[i + j].append(partial_products[i][j])

        return WallaceStage(input_signal_lists, 1)

    def build(self):
        self.stages.append(self._get_first_stage(self.operands_size_bits))
        print(f"Building stage 1")
        self.stages[-1].build()
        print(self.stages[-1])

        stage_num = 2
        while not self.stages[-1].is_final_stage():
            self.stages.append(WallaceStage(self.stages[-1].output_signal_lists, stage_num))
            print(f"Building stage {stage_num}")
            self.stages[-1].build()
            print(self.stages[-1])
            stage_num += 1

        self.ripple_carry_adder = RippleCarryAdder(self.stages[-1].output_signal_lists)
        self.ripple_carry_adder.build()

    def get_declared_signals(self) -> List[Signal]:
        return [signal for stage in self.stages for signal in stage.get_declared_signals()] \
               + self.partial_products_builder.get_declared_signals() \
               + self.ripple_carry_adder.get_declared_signals()

    def get_component_instances(self) -> List[AbstractComponentInstance]:
        return list(itertools.chain.from_iterable([stage.get_component_instances() for stage in self.stages])) \
               + self.partial_products_builder.get_component_instances() \
               + self.ripple_carry_adder.get_component_instances()
