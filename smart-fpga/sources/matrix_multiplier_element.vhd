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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix_multiplier_element is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in std_logic;
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
    signal s_full_product : std_logic_vector(SCALAR_LENGTH * 2 - 1 downto 0);
    signal s_rst_sum : std_logic;
begin
    
    s_product <= scalar(s_full_product(SCALAR_LENGTH - 1 downto 0));
    process (i_clk, i_rst) begin
        if i_rst = '1' then
            o_req_result <= '0';
            o_bottom <= (others => '0');
            o_right <= (others => '0');
            o_data_bus <= (others => 'Z');
            s_sum <= (others => '0');
            s_full_product <= (others => '0');
            s_rst_sum <= '0';
        else
            if rising_edge(i_clk) then
                o_right <= i_left;
                o_bottom <= i_top;
                s_full_product <= std_logic_vector(signed(i_left) * signed(i_top));
                o_req_result <= i_req_result;
                
                -- pipeline logic
                
                -- if i_req_result = '1' then
                --     s_rst_sum <= '1';
                -- else
                --     s_rst_sum <= '0';
                -- end if;
                
                if i_req_result = '1' then
                    s_sum <= s_product;
                    -- s_rst_sum <= '0';
                    o_data_bus <= s_sum;
                else
                    s_sum <= std_logic_vector(signed(s_sum) + signed(s_product));
                    o_data_bus <= (others => 'Z');
                end if;
            end if;
        end if;
    end process;

end Behavioral;
