/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:31 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/01 07:08:57 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "client.h"

volatile int	g_handshake = 0;

static void	ft_handle_msg_error(char *str);
static void	ft_handler_action(int signal);
static void	ft_send_data(int server_pid, char chr);

int	main(int argc, char **argv)
{
	int					server_pid;
	struct sigaction	client_action;

	if (argc != 3)
		ft_handle_msg_error("Wrong number of arguments.\n");
	server_pid = ft_atoi(argv[1]);
	while (*argv[1])
	{
		if (!ft_isdigit(*argv[1]++))
			ft_handle_msg_error("Wrong PID.\n");
	}
	client_action.sa_handler = ft_handler_action;
	client_action.sa_flags = 0;
	if (sigaction(SIGUSR1, &client_action, NULL) == FAIL_)
		ft_handle_msg_error("Server signal fail.\n");
	while (*argv[2])
		ft_send_data(server_pid, *argv[2]++);
}

static void	ft_handle_msg_error(char *str)
{
	ft_putstr_fd("\033[0;31mError - \033[0m", STDERR_FILENO);
	ft_putstr_fd(str, STDERR_FILENO);
	exit(EXIT_FAILURE);
}

static void	ft_handler_action(int signal)
{
	if (signal == SIGUSR1)
		g_handshake = 1;
}

static void	ft_send_data(int server_pid, char chr)
{
	int	count_bit;

	count_bit = 8;
	while (--count_bit >= 0)
	{
		g_handshake = 0;
		if (((chr >> count_bit) & 1) == 0)
		{
			if (kill(server_pid, SIGUSR1))
				exit(EXIT_FAILURE);
		}
		else if (((chr >> count_bit) & 1) == 1)
		{
			if (kill(server_pid, SIGUSR2))
				exit(EXIT_FAILURE);
		}
		while (!g_handshake)
			pause();
	}
}
