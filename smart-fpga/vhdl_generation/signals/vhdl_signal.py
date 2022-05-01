from enum import Enum
from dataclasses import dataclass
from typing import *


class SignalType(Enum):
    INPUT = 0


@dataclass
class Signal:
    name: str
    stage: Optional[int] = None


