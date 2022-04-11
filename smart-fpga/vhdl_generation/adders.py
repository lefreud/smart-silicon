from dataclasses import dataclass
from vhdl_signal import Signal


@dataclass
class FullAdder:
    a: Signal
    b: Signal
    carry_in: Signal
    sum: Signal
    carry_out: Signal


@dataclass
class HalfAdder:
    a: Signal
    b: Signal
    sum: Signal
    carry_out: Signal
