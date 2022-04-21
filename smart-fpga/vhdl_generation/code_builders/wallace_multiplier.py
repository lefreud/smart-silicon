from typing import *
from code_builders.abstract_code_builder import AbstractCodeBuilder
from component_instances.abstract_component_instance import AbstractComponentInstance
from signals.vhdl_signal import Signal
from code_builders.wallace_stage import WallaceStage
from code_builders.partial_products import PartialProductsBuilder
from code_builders.ripple_carry_adder import RippleCarryAdder
from component_instances.assignment import Assignment
from component_instances.carry_bypass_adder import CarryBypassAdder
import itertools


class WallaceMultiplier(AbstractCodeBuilder):
    def __init__(self, operands_size_bits):
        self.operands_size_bits = operands_size_bits
        self.stages = []
        self.partial_products_builder = None
        self.carry_bypass_adder = None
        self.carry_bypass_adder_assignments = None

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

        a = [s[0] for s in self.stages[-1].output_signal_lists]
        b = [s[1] for s in self.stages[-1].output_signal_lists if len(s) > 1]
        self.carry_bypass_adder_assignments = \
            [Assignment(Signal("carry_bypass_a"), Signal("'0' & " + ' & '.join(s.name for s in reversed(a)))),
             Assignment(Signal("carry_bypass_b"), Signal("'0' & " + ' & '.join(s.name for s in reversed(b)) + " & '0'"))]
        self.carry_bypass_adder = CarryBypassAdder("carry_bypass_adder_0", Signal("carry_bypass_a"),
                                                   Signal("carry_bypass_b"))

    def get_declared_signals(self) -> List[Signal]:
        return [signal for stage in self.stages for signal in stage.get_declared_signals()] \
               + self.partial_products_builder.get_declared_signals()

    def get_component_instances(self) -> List[AbstractComponentInstance]:
        return list(itertools.chain.from_iterable([stage.get_component_instances() for stage in self.stages])) \
               + self.partial_products_builder.get_component_instances() \
               + [self.carry_bypass_adder] + \
               self.carry_bypass_adder_assignments
