----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 01:36:21 PM
-- Design Name: 
-- Module Name: delay_reg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_reg is
    generic ( width : integer; delay : integer );
    Port ( i_clk : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (width - 1 downto 0);
           o_data : out STD_LOGIC_VECTOR (width - 1 downto 0));
end delay_reg;

architecture Behavioral of delay_reg is

    component reg is
        generic ( width : integer );
        Port ( i_clk : in STD_LOGIC;
               i_data : in STD_LOGIC_VECTOR (width - 1 downto 0);
               o_data : out STD_LOGIC_VECTOR (width - 1 downto 0));
    end component;
    
    type type_delay_data is array(delay - 1 downto 0) of STD_LOGIC_VECTOR (width - 1 downto 0);
    signal s_data : type_delay_data;
begin

inst_regs:
    for i in 0 to delay - 1 generate
inst_reg0:        
        if i = 0 generate
inst_reg:
            reg 
            generic map ( width => width )
            port map (
                i_clk => i_clk,
                i_data => i_data,
                o_data => s_data(i)
            );
        else generate
inst_reg:
            reg 
            generic map ( width => width )
            port map (
                i_clk => i_clk,
                i_data => s_data(i-1),
                o_data => s_data(i)
            );
        end generate;
    end generate;

inst_delay :
    if delay = 0 generate
        o_data <= i_data;
    else generate
        o_data <= s_data(delay - 1);
    end generate;
end Behavioral;
