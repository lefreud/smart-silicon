----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 12:00:22 PM
-- Design Name: 
-- Module Name: matrix_multiplier_element - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.SmartPackage.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix_multiplier_element is
    Port ( i_clk : in STD_LOGIC;
           i_left : in scalar;
           i_top : in scalar;
           i_req_result : in STD_LOGIC;
           o_req_result: out std_logic;
           o_bottom : out scalar;
           o_right : out scalar;
           o_data_bus : out scalar);
end matrix_multiplier_element;

architecture Behavioral of matrix_multiplier_element is
    signal s_sum : scalar;
    signal s_product : scalar;
begin

    process (i_clk) begin
        if rising_edge(i_clk) then
            o_right <= i_left;
            o_bottom <= i_top;
            s_product <= signed(i_left) * signed(i_top);
            o_req_result <= i_req_result;
            
            if i_req_result = '1' then
                o_data_bus <= s_sum;
                s_sum <= (others => '0');
            else
                o_data_bus <= (others => 'Z');
                s_sum <= signed(s_sum) + signed(s_product);
            end if;
        end if;
    end process;

end Behavioral;
