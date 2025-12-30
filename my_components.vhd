library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package my_components is

	component comparador is
		generic(constant N: integer := 6);
		port(A,B: in std_logic_vector(N-1 downto 0);EQ: out std_logic);
	end component;
	
	component counter_mod is
		generic(constant M: integer := 60;constant N: integer := 6); 
		port(g_reset_n,en,clk: in std_logic;
					valor_inicial: in std_logic_vector(N-1 downto 0);
				q: out std_logic_vector(N-1 downto 0));
	end component;	
	
	component selector_modo is
		generic(constant A: integer := 1;
					constant BC: integer := 20;
					constant DE: integer := 20);
		port(sel: in std_logic_vector(1 downto 0);
			tiempo: out std_logic_vector(13 downto 0));
	end component;	
	
	component divisor_freq is
	  generic (N         : natural := 50000000;        
				  BUS_WIDTH : natural := 26);
	  port (signal reset_n :  in std_logic;
			  signal clk     :  in std_logic;
			  signal clk_o   : out std_logic);
	end component;
		
	component bintobcd is
	  port(signal a  :  in std_logic_vector(5 downto 0);
			signal f  : out std_logic_vector(7 downto 0)) ;
	end component;	
	
	component hexa is
	  port(signal a  :  in std_logic_vector(3 downto 0);
			 signal f  : out std_logic_vector(6 downto 0)) ;
	end component;	
	
	component Mux4a1 is
		port(a00,a01,a10,a11: in std_logic_vector(6 downto 0);
								sel: in std_logic_vector(1 downto 0);
								f: out std_logic_vector(6 downto 0));
	end component;


	component fsm is
		port(en,reset_n,clk,config,ini_pausa,jugador_act,min_value_j0,min_value_j1,mov_j0_gt40,mov_j1_gt40: in std_logic;
																			modo: in std_logic_vector(1 downto 0)
									;	ini_pausa_j0,borrar_j0,ini_pausa_j1,borrar_j1,en_sel,en_j1,en_j0:out std_logic);
	end component;
	
	component reg_d is
		port(en_sel,reset_n,clk: in std_logic;
						modo: in std_logic_vector(1 downto 0);
						modo_reg: out std_logic_vector(1 downto 0));
						
	end component;	
	
	component reloj is
		port(reset_n,clk,ini_pausa,borrar: in std_logic;
				sel: in std_logic_vector(1 downto 0);
				mov_restricciones: in std_logic;
				display_0,display_1,display_2,display_3,display_4,display_5: out std_logic_vector(6 downto 0);
				min_value: out std_logic);
	end component;
	
	component bintobcd_12 is
	  port(
			signal a : in  std_logic_vector(7 downto 0);
			signal f : out std_logic_vector(11 downto 0)
	  );
	end component;


	component contador_asc is
		 port(
			  clk, en      : in  std_logic;
			  reset_n      : in  std_logic;

			  mov_u, mov_d, mov_c : out std_logic_vector(6 downto 0);

			  mov_gt16, mov_gt40 : out std_logic
		 );
	end component;
	
	component counter_horas is
		generic(constant M: integer := 3;constant N: integer := 2); 
		port(g_reset_n,en,clk,mov_restricciones: in std_logic;
					valor_inicial: in std_logic_vector(1 downto 0);
				q: out std_logic_vector(N-1 downto 0));
	end component;

	
	component generador_leds is
		generic(constant M: integer := 10);--configurar M para que de señal de 1 Hz de manera que : M*2 = 1/frecuencia de clk_in
		port(reset,clk,min_value_j0,min_value_j1: in std_logic; clk_out : out std_logic;leds: out std_logic_vector(9 downto 0));
	end component;

	
end my_components;