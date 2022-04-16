from dataclasses import dataclass
from signals.vhdl_signal import Signal
from component_instances.abstract_component_instance import AbstractComponentInstance


@dataclass
class AndGate(AbstractComponentInstance):
    a: Signal
    b: Signal
    out: Signal

    def get_code(self) -> str:
        return f"""
        {self.out.name} <= {self.a.name} and {self.b.name};
        """
