library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.SmartPackage.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix_multiplier is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_left : in vector;
           i_top : in vector;
           i_data_rdy : in STD_LOGIC;
           o_data_rdy : out STD_LOGIC;
           o_data : out vector
           );
end matrix_multiplier;

architecture Behavioral of matrix_multiplier is
    type bit_matrix is array(VECTOR_LENGTH - 1 downto 0, VECTOR_LENGTH - 1 downto 0) of STD_LOGIC;

    signal s_horizontal_paths : matrix;
    signal s_vertical_paths : matrix;
    signal s_req_result : bit_matrix;
    signal s_data_bus : vector;
    
    component matrix_multiplier_element is
        Port ( i_clk : in STD_LOGIC;
               i_left : in scalar;
               i_top : in scalar;
               i_req_result : in STD_LOGIC;
               o_req_result: out std_logic;
               o_bottom : out scalar;
               o_right : out scalar;
               o_data_bus : out scalar);
    end component;
begin

inst_top :
    for column in 0 to VECTOR_LENGTH - 1 generate
        s_vertical_paths(0, column) <= i_top(column);
    end generate;

inst_left :
    for row in 0 to VECTOR_LENGTH - 1 generate
        s_horizontal_paths(row, 0) <= i_left(row);
    end generate;

inst_elements_rows : 
    for row in 0 to VECTOR_LENGTH - 1 generate
inst_elements_cols : 
        for column in 0 to VECTOR_LENGTH - 1 generate
inst_element_last_row :
            if row < VECTOR_LENGTH - 1 generate
inst_element_reg_rows : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_left => s_horizontal_paths(row, column),
                           i_top => s_vertical_paths(row, column),
                           i_req_result => s_req_result(row, column),
                           o_req_result => s_req_result(row, column + 1),
                           o_bottom => s_vertical_paths(row + 1, column),
                           o_right => s_horizontal_paths(row, column + 1),
                           o_data_bus => s_data_bus(column));
            else generate
inst_element_last_row : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_left => s_horizontal_paths(row, column),
                           i_top => s_vertical_paths(row, column),
                           i_req_result => s_req_result(row, column),
                           o_req_result => open,
                           o_bottom => open,
                           o_right => open,
                           o_data_bus => s_data_bus(column));
            end generate;
        end generate;
    end generate;

end Behavioral;
