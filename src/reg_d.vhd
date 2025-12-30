library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_d is
	port(en_sel,reset_n,clk: in std_logic;
					modo: in std_logic_vector(1 downto 0);
					modo_reg: out std_logic_vector(1 downto 0));
					
end reg_d;

architecture arch of reg_d is
	signal q_reg: std_logic_vector(1 downto 0);
	begin
		process(reset_n,clk)
			begin
				if reset_n = '0' then
					q_reg <= (others => '0');
				elsif rising_edge(clk) then
					if en_sel = '1' then
						q_reg <= modo;
					end if;
				end if;
		end process;
		modo_reg <= q_reg;
end arch;