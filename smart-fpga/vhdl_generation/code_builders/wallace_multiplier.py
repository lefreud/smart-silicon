from typing import *
from code_builders.abstract_code_builder import AbstractCodeBuilder
from component_instances.abstract_component_instance import AbstractComponentInstance
from signals.vhdl_signal import Signal


class WallaceMultiplier(AbstractCodeBuilder):
    def get_declared_signals(self) -> List[Signal]:
        pass

    def get_component_instances(self) -> List[AbstractComponentInstance]:
        pass
