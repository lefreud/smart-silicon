from enum import Enum


class SignalType(Enum):
    INPUT = 0


class Signal:
    def __init__(self, stage_index):
        self.stage_index = stage_index

    def __str__(self):
        return str(self.stage_index)

