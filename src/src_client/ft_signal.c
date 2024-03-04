/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_signal.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/04 01:06:57 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 01:49:46 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include "ft_string.h"
#include "ft_client.h"
#include "ft_utils.h"

static void	ft_handler_action(int signal);
static int	ft_handshake(int value, int check);

void	ft_signal(int server_pid, char *msg)
{
	struct sigaction	client_action;

	ft_memset(&client_action, DEFAULT, sizeof(client_action));
	client_action.sa_flags = DEFAULT;
	client_action.sa_handler = ft_handler_action;
	if (sigaction(SIGUSR1, &client_action, NULL) == CLIENT_FAIL \
		|| sigaction(SIGUSR2, &client_action, NULL) == CLIENT_FAIL)
		ft_handle_msg_error("Client signal fail to start.\n");
	ft_handle_msg(server_pid, msg);
}

void	ft_send_signal(int server_pid, char chr)
{
	int	count_bit;

	count_bit = BYTE_SIZE;
	while (--count_bit >= DEFAULT)
	{
		ft_handshake(DEFAULT, SET);
		if (((chr >> count_bit) & BIT) == SIGNAL_OFF)
		{
			if (kill(server_pid, SIGUSR1))
				ft_handle_msg_error("Server offline or wrong PID.\n");
		}
		else if (((chr >> count_bit) & BIT) == SIGNAL_ON)
			if (kill(server_pid, SIGUSR2))
				ft_handle_msg_error("Server offline or wrong PID.\n");
		while (!ft_handshake(DEFAULT, GET))
			;
	}
}

static void	ft_handler_action(int signal)
{
	if (signal == SIGUSR1)
		ft_handshake(SET, SET);
}

static int	ft_handshake(int value, int check)
{
	static volatile int	handshake;

	if (check == SET)
		handshake = value;
	return (handshake);
}
