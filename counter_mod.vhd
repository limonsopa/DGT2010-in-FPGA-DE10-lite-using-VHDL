library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity counter_mod is
	generic(constant M: integer := 60;constant N: integer := 6); 
	port(g_reset_n,en,clk: in std_logic;
				valor_inicial: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0));
end counter_mod;



architecture arch of counter_mod is
	signal q_reg,q_next: unsigned(N-1 downto 0);
	begin
		process(g_reset_n,clk,valor_inicial)
			begin
				if g_reset_n = '0' then
					q_reg <= unsigned(valor_inicial);
				elsif rising_edge(clk) then
					q_reg <= q_next;
				end if;
		end process;
		
		process(en,q_reg)
			begin
				if en = '1' then
					if (q_reg = to_unsigned(0,N)) then
						q_next <= to_unsigned(M-1,N);
					else
						q_next <= q_reg - 1;
					end if;
				else
					q_next <= q_reg;
				end if;
		end process;
		--CUENTA ACTUAL
		q <= std_logic_vector(q_reg);
end arch;