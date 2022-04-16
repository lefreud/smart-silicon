library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    generic ( width : integer );
    Port ( CLK : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (width - 1 downto 0);
           o_data : out STD_LOGIC_VECTOR (width - 1 downto 0));
end reg;

architecture Behavioral of reg is

begin

    process (CLK, rst) begin
        if rst = '1' then
            o_data <= (others => '0');
        elsif rising_edge(CLK) and en = '1' then
            o_data <= i_data;
        end if;
    end process;

end Behavioral;
