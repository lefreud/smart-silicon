----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 09:41:10 PM
-- Design Name: 
-- Module Name: matrix_multiplier_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix_multiplier_tb is
--  Port ( );
end matrix_multiplier_tb;

architecture Behavioral of matrix_multiplier_tb is
    component matrix_multiplier is
        Port ( CLK : in STD_LOGIC;
               en : in STD_LOGIC;
               i_rst : in std_logic;
               i_left : in vector;
               i_top : in vector;
               i_req_result : in STD_LOGIC;
               o_data : out vector
               );
    end component;
    
    signal s_clk : STD_LOGIC;
    signal s_en : std_logic;
    signal s_rst : std_logic;
    signal s_left : vector;
    signal s_top : vector;
    signal s_req_result : STD_LOGIC;
    signal s_data : vector;
    
    constant clk_period : time := 1 ns;
begin

    UUT : matrix_multiplier
        Port map ( CLK => s_clk,
               en => s_en,
               i_rst => s_rst,
               i_left => s_left,
               i_top => s_top,
               i_req_result => s_req_result,
               o_data => s_data
               );
    
    process begin
        s_clk <= '0';
        wait for clk_period / 2;
        s_clk <= '1';
        wait for clk_period / 2;
    end process;
        
    process begin
    
        -- test :
        -- left: A, top: B, s_data: C
        -- A=[[0x0 0x1 0x2 0x3]
        --    [0x4 0x5 0x6 0x7]
        --    [0x8 0x9 0xa 0xb]
        --    [0xc 0xd 0xe 0xf]]
        -- B=[[0x10 0x11 0x12 0x13]
        --    [0x14 0x15 0x16 0x17]
        --    [0x18 0x19 0x1a 0x1b]
        --    [0x1c 0x1d 0x1e 0x1f]]
        -- C=A*B=[[0x98  0x9e  0xa4  0xaa]
        --        [0x1f8 0x20e 0x224 0x23a]
        --        [0x358 0x37e 0x3a4 0x3ca]
        --        [0x4b8 0x4ee 0x524 0x55a]]
        
        wait for 5 ns;
        s_left <= (X"0000", X"0000", X"0000", X"0000");
        s_top <= (X"0000", X"0000", X"0000", X"0000"); -- todo: comment?
        s_rst <= '1';
        s_en <= '0';
        s_req_result <= '0';
        wait for 5 ns;
        
        -- auto-generated in python script
        s_rst <= '0';
        wait for 5 * clk_period;
        s_en <= '1';
        wait for 5 * clk_period;
        
        s_req_result <= '1';
        s_left <= (X"000f", X"000b", X"0007", X"0003");
        s_top <= (X"001f", X"001e", X"001d", X"001c");
        wait for clk_period;
        s_req_result <= '0';
        s_left <= (X"000e", X"000a", X"0006", X"0002");
        s_top <= (X"001b", X"001a", X"0019", X"0018");
        wait for clk_period;
        s_req_result <= '0';
        s_left <= (X"000d", X"0009", X"0005", X"0001");
        s_top <= (X"0017", X"0016", X"0015", X"0014");
        wait for clk_period;
        s_req_result <= '0';
        s_left <= (X"000c", X"0008", X"0004", X"0000");
        s_top <= (X"0013", X"0012", X"0011", X"0010");
        wait for clk_period;
        s_top <= (X"0000", X"0000", X"0000", X"0000");
        s_left <= (X"0000", X"0000", X"0000", X"0000");
        s_req_result <= '1';
        wait for clk_period;
        s_req_result <= '0';
        wait;
    end process;

end Behavioral;
