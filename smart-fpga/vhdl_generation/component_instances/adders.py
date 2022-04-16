from dataclasses import dataclass
from signals.vhdl_signal import Signal
from component_instances.abstract_component_instance import AbstractComponentInstance


@dataclass
class FullAdder(AbstractComponentInstance):
    name: str
    a: Signal
    b: Signal
    carry_in: Signal
    sum: Signal
    carry_out: Signal

    def get_code(self) -> str:
        return f"""
        {self.name} : full_adder
            port map (
                a => {self.a.name},
                b => {self.b.name},
                Cin => {self.carry_in.name},
                s => {self.sum.name},
                Cout => {self.carry_out.name}
            );
        """


@dataclass
class HalfAdder(AbstractComponentInstance):
    name: str
    a: Signal
    b: Signal
    sum: Signal
    carry_out: Signal

    def get_code(self) -> str:
        return f"""
        {self.name} : half_adder
            port map (
                a => {self.a.name},
                b => {self.b.name},
                s => {self.sum.name},
                Cout => {self.carry_out.name}
            );
        """
