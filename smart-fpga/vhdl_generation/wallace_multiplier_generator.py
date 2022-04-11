import os.path
from pathlib import Path
from string import Template
from wallace_stage import WallaceStage, get_first_stage


VHDL_SOURCES_FOLDER = Path(os.path.dirname(__file__)).parent / "sources"
WALLACE_MULTIPLIER_TEMPLATE_PATH = Path(os.path.dirname(__file__)) / "wallace_multiplier.vhd.template"


def generate_wallace_vhdl_code(operands_size_bits):
    with open(WALLACE_MULTIPLIER_TEMPLATE_PATH) as f:
        template = Template(f.read())

        stage = get_first_stage(operands_size_bits)
        stage_num = 2
        while not stage.is_final_stage():
            stage.reduce()
            print(stage)
            stage = WallaceStage(stage.output_signal_lists, stage_num)
            stage_num += 1

        result = template.substitute({
            "signal_definitions": "signal",
            "stages": stage.vhdl_code
        })

    return result


def main():
    with open(VHDL_SOURCES_FOLDER / "wallace_multiplier.vhdl", "w") as f:
        f.write(generate_wallace_vhdl_code(16))


if __name__ == "__main__":
    main()
