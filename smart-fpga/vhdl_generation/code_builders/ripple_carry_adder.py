from typing import List
from code_builders.abstract_code_builder import AbstractCodeBuilder
from component_instances.abstract_component_instance import AbstractComponentInstance
from signals.vhdl_signal import Signal
from component_instances.adders import FullAdder, HalfAdder
from component_instances.assignment import Assignment


class RippleCarryAdder(AbstractCodeBuilder):
    def __init__(self, signals_lists):
        self.signals_lists = signals_lists

        self.output_signals = []
        self.full_adders = []
        self.half_adders = []
        self.assignments = []
        self.carries = [Signal('\'0\'')]

    def build(self):
        self.assignments.append(Assignment(Signal("c(0)"), self.signals_lists[0][0]))
        for i in range(1, len(self.signals_lists)):
            carry = Signal(f'ripple_carry_{i}')
            self.carries.append(carry)
            self.output_signals.append(Signal(f"c({i})"))

            if len(self.signals_lists[i]) == 1:
                self.half_adders.append(HalfAdder(a=self.signals_lists[i][0],
                                                  b=self.carries[i - 1],
                                                  carry_out=carry,
                                                  name=f'full_adder_{i}',
                                                  sum=self.output_signals[-1]))
            else:
                self.full_adders.append(FullAdder(
                    a=self.signals_lists[i][0],
                    b=self.signals_lists[i][1],
                    carry_in=self.carries[i - 1],
                    carry_out=carry,
                    name=f'full_adder_{i}',
                    sum=self.output_signals[-1])
                )

    def get_declared_signals(self) -> List[Signal]:
        return self.carries[1:]

    def get_component_instances(self) -> List[AbstractComponentInstance]:
        return self.full_adders + self.half_adders + self.assignments
