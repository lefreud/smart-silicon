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
           i_rst : in std_logic;
           i_left : in vector;
           i_top : in vector;
           i_req_result : in STD_LOGIC;
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
               i_rst : in std_logic;
               i_left : in scalar;
               i_top : in scalar;
               i_req_result : in STD_LOGIC; -- TODO: maybe use i_req_result as reset signal for PEs?
               o_req_result : out std_logic;
               o_bottom : out scalar;
               o_right : out scalar;
               o_data_bus : out scalar);
    end component;
    
    component delay_reg is
        generic ( width : integer; delay : integer );
        Port ( i_clk : in STD_LOGIC;
               i_data : in STD_LOGIC_VECTOR (width - 1 downto 0);
               o_data : out STD_LOGIC_VECTOR (width - 1 downto 0));
    end component;
begin

inst_top :
    for column in 0 to VECTOR_LENGTH - 1 generate
inst_delay :
        delay_reg
        generic map ( width => SCALAR_LENGTH, delay => column )
        port map ( i_clk => i_clk,
               i_data => i_top(column),
               o_data => s_vertical_paths(0, column));
    end generate;

inst_top_req_result :
    for column in 0 to VECTOR_LENGTH - 1 generate
inst_delay :
        delay_reg
        generic map ( width => 1, delay => column + 1 )
        port map ( i_clk => i_clk,
               i_data(0) => i_req_result,
               o_data(0) => s_req_result(0, column));
    end generate;

inst_left :
    for row in 0 to VECTOR_LENGTH - 1 generate
inst_delay:
        delay_reg
        generic map ( width => SCALAR_LENGTH, delay => row )
        port map ( i_clk => i_clk,
                i_data => i_left(row),
                o_data => s_horizontal_paths(row, 0));
    end generate;

inst_elements_rows : 
    for row in 0 to VECTOR_LENGTH - 1 generate
inst_elements_cols : 
        for column in 0 to VECTOR_LENGTH - 1 generate
inst_element_reg :
            if row < VECTOR_LENGTH - 1 and column < VECTOR_LENGTH - 1 generate
inst_element_reg_0 : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_rst => i_rst,
                           i_left => s_horizontal_paths(row, column),
                           i_top => s_vertical_paths(row, column),
                           i_req_result => s_req_result(row, column),
                           o_req_result => s_req_result(row + 1, column),
                           o_bottom => s_vertical_paths(row + 1, column),
                           o_right => s_horizontal_paths(row, column + 1),
                           o_data_bus => s_data_bus(column));
            elsif row < VECTOR_LENGTH - 1 generate
inst_element_reg_1 : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_rst => i_rst,
                           i_left => s_horizontal_paths(row, column),
                           i_top => s_vertical_paths(row, column),
                           i_req_result => s_req_result(row, column),
                           o_req_result => s_req_result(row + 1, column),
                           o_bottom => s_vertical_paths(row + 1, column),
                           o_right => open,
                           o_data_bus => s_data_bus(column));
            elsif column < VECTOR_LENGTH - 1 generate
inst_element_reg_2 : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_rst => i_rst,
                           i_left => s_horizontal_paths(row, column),
                           i_top => s_vertical_paths(row, column),
                           i_req_result => s_req_result(row, column),
                           o_req_result => open,
                           o_bottom => open,
                           o_right => s_horizontal_paths(row, column + 1),
                           o_data_bus => s_data_bus(column));
            else generate
inst_element_last_3 : 
                matrix_multiplier_element 
                    port map ( i_clk => i_clk,
                           i_rst => i_rst,
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
    
    o_data <= s_data_bus;
end Behavioral;
