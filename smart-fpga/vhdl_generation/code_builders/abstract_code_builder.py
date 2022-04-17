from typing import *
from signals.vhdl_signal import Signal
from component_instances.abstract_component_instance import AbstractComponentInstance
from abc import ABC, abstractmethod


class AbstractCodeBuilder(ABC):
    @abstractmethod
    def build(self):
        ...

    @abstractmethod
    def get_declared_signals(self) -> List[Signal]:
        ...

    @abstractmethod
    def get_component_instances(self) -> List[AbstractComponentInstance]:
        ...

    def get_signals_declaration_code(self):
        x = self.get_declared_signals()
        a = [f"signal {x[i].name} : std_logic;" for i in range(len(x))]
        return '\n'.join([f"signal {x[i].name} : std_logic;" for i in range(len(x))])

    def get_component_instances_code(self):
        return '\n'.join([component_instance.get_code() for component_instance in self.get_component_instances()])
