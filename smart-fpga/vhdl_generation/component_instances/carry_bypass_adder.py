from dataclasses import dataclass
from signals.vhdl_signal import Signal
from component_instances.abstract_component_instance import AbstractComponentInstance
from typing import List


@dataclass
class CarryBypassAdder(AbstractComponentInstance):
    name: str
    a: Signal
    b: Signal

    def get_code(self) -> str:
        return f"""
        {self.name} : carry_bypass_adder
            port map (
                a => {self.a.name},
                b => {self.b.name},
                s => c_temp
            );
        """


