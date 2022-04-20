from signals.vhdl_signal import Signal
from typing import *
from component_instances.adders import HalfAdder, FullAdder
from code_builders.abstract_code_builder import AbstractCodeBuilder
from random import randint


class WallaceStage(AbstractCodeBuilder):
    def __init__(self, input_signal_lists: List[List[Signal]], stage_index):
        self.input_signal_lists = input_signal_lists
        self.full_adders = None
        self.half_adders = None
        self.output_signal_lists: List[List[Signal]] = []
        self.stage_index = stage_index
        self.declared_signals = []

    def get_declared_signals(self):
        return self.declared_signals

    def get_component_instances(self):
        return self.full_adders + self.half_adders

    def build(self):
        self.full_adders = []
        self.half_adders = []
        self.output_signal_lists = []

        # Copy input signals to output
        for input_list_input in self.input_signal_lists:
            self.output_signal_lists.append([])
            for signal in input_list_input:
                self.output_signal_lists[-1].append(signal)

        longest_list_size, longest_list_column = 0, -1
        for column in range(len(self.input_signal_lists)):
            if len(self.input_signal_lists[column]) > longest_list_size:
                longest_list_column = column
                longest_list_size = len(self.input_signal_lists[column])

        self.add_half_adder(longest_list_column)
        last_long_column = None
        for column in range(longest_list_column + 1, len(self.input_signal_lists)):
            if len(self.input_signal_lists[column]) < longest_list_size:
                last_long_column = column - 1
                break
            if len(self.input_signal_lists[column]) < 3:
                print(f"Column {column} is too short")
            self.add_full_adder(column)

        if len(self.input_signal_lists[last_long_column + 1]) == longest_list_size - 1:
            self.add_half_adder(last_long_column + 1)

    def add_full_adder(self, column):
        new_sum = Signal(f"sum_{randint(0, 1000000)}", self.stage_index)
        new_carry_out = Signal(f"cout_{randint(0, 1000000)}", self.stage_index)
        self.declared_signals.append(new_sum)
        self.declared_signals.append(new_carry_out)
        self.full_adders.append(FullAdder(
            a=self.input_signal_lists[column][-1],
            b=self.input_signal_lists[column][-2],
            carry_in=self.input_signal_lists[column][-3],
            sum=new_sum,
            carry_out=new_carry_out,
            name=f"full_adder_{randint(0, 100000)}"
        ))
        self.output_signal_lists[column].remove(self.input_signal_lists[column][-1])
        self.output_signal_lists[column].remove(self.input_signal_lists[column][-2])
        self.output_signal_lists[column].remove(self.input_signal_lists[column][-3])
        self.output_signal_lists[column].append(new_sum)
        self.output_signal_lists[column + 1].append(new_carry_out)

    def add_half_adder(self, column):
        new_sum = Signal(f"sum_{randint(0, 1000000)}", self.stage_index)
        new_carry_out = Signal(f"cout_{randint(0, 1000000)}", self.stage_index)
        self.declared_signals.append(new_sum)
        self.declared_signals.append(new_carry_out)
        self.half_adders.append(HalfAdder(
            a=self.input_signal_lists[column][-1],
            b=self.input_signal_lists[column][-2],
            sum=new_sum,
            carry_out=new_carry_out,
            name=f"half_adder_{randint(0, 100000)}"
        ))
        self.output_signal_lists[column].remove(self.input_signal_lists[column][-1])
        self.output_signal_lists[column].remove(self.input_signal_lists[column][-2])
        self.output_signal_lists[column].append(new_sum)
        self.output_signal_lists[column + 1].append(new_carry_out)

    def __str__(self):
        return self._signal_lists_to_str(self.output_signal_lists)

    def _signal_lists_to_str(self, lists):
        longest_list_size = 0
        for column in range(len(lists)):
            if len(lists[column]) > longest_list_size:
                longest_list_size = len(lists[column])

        out = ""
        for row in range(longest_list_size):
            for column in range(len(lists) - 1, -1, -1):
                if len(lists[column]) > row:
                    out += f"{lists[column][row].stage:02}|"
                else:
                    out += "   "
            out += "\n"
        return out

    def is_final_stage(self):
        for input_signal_list in self.input_signal_lists:
            if len(input_signal_list) > 3:
                return False
        return True
