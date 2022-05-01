import os.path
from pathlib import Path
from string import Template
from code_builders.wallace_multiplier import WallaceMultiplier


VHDL_SOURCES_FOLDER = Path(os.path.dirname(__file__)).parent / "sources"
WALLACE_MULTIPLIER_TEMPLATE_PATH = Path(os.path.dirname(__file__)) / "wallace_multiplier.vhd.template"


def generate_wallace_vhdl_code(operands_size_bits):
    with open(WALLACE_MULTIPLIER_TEMPLATE_PATH) as f:
        template = Template(f.read())

        wallace_multiplier = WallaceMultiplier(operands_size_bits)
        wallace_multiplier.build()

        result = template.substitute({
            "output_size_bits": operands_size_bits * 2 - 1,
            "operands_size_bits": operands_size_bits,
            "signal_definitions": wallace_multiplier.get_signals_declaration_code(),
            "component_instances": wallace_multiplier.get_component_instances_code(),
        })

    return result


def main():
    with open(VHDL_SOURCES_FOLDER / "wallace_multiplier.vhdl", "w") as f:
        f.write(generate_wallace_vhdl_code(16))


if __name__ == "__main__":
    main()
