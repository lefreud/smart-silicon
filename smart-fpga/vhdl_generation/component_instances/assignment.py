from component_instances.abstract_component_instance import AbstractComponentInstance


class Assignment(AbstractComponentInstance):
    def __init__(self, left, right):
        self.left = left
        self.right = right

    def get_code(self) -> str:
        return f"{self.left.name} <= {self.right.name};"
