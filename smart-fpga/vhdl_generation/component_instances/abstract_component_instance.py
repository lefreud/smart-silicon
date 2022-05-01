from abc import ABC, abstractmethod


class AbstractComponentInstance(ABC):
    @abstractmethod
    def get_code(self) -> str:
        ...
