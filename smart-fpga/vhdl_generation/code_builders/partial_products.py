from signals.vhdl_signal import Signal
from typing import *
from component_instances.logic_gates import *
from code_builders.abstract_code_builder import AbstractCodeBuilder
import itertools


class PartialProductsBuilder(AbstractCodeBuilder):
    def __init__(self, a_signals: List[Signal], b_signals: List[Signal]):
        self.a_signals = a_signals
        self.b_signals = b_signals
        self.partial_products = []
        self.declared_signals = []
        self.and_gates = []

    def build(self):
        for i in range(len(self.b_signals)):
            self.partial_products.append([])
            for j in range(len(self.a_signals)):
                out = Signal(f"pp_{j}_{i}", 0)
                self.and_gates.append(AndGate(self.a_signals[j], self.b_signals[i], out))
                self.partial_products[i].append(out)
                self.declared_signals.append(out)

        print()

    def get_partial_products(self):
        return self.partial_products

    def get_declared_signals(self):
        return self.declared_signals

    def get_component_instances(self):
        return self.and_gates
