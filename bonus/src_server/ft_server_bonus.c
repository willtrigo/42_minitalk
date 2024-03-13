/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_server_bonus.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:37 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/13 03:29:54 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <signal.h>
#include <unistd.h>
#include "ft_non_standard/ft_non_standard.h"
#include "ft_string.h"
#include "ft_server_bonus.h"

static void	ft_handler_action(int signal, siginfo_t *info, \
				__attribute__((unused))void *ucontext);
static void	ft_handle_msg_error(char *str);

int	main(void)
{
	struct sigaction	server_action;

	ft_memset(&server_action, DEFAULT, sizeof(server_action));
	server_action.sa_flags = SA_SIGINFO;
	server_action.sa_sigaction = ft_handler_action;
	if (sigaction(SIGUSR1, &server_action, NULL) == SERVER_FAIL \
		|| sigaction(SIGUSR2, &server_action, NULL) == SERVER_FAIL)
		ft_handle_msg_error("\033[0;31mError - Server signal fail.\n");
	ft_putstr_fd("\033[0;35mServer PID: \033[0;36m", BIT);
	ft_putnbr_fd(getpid(), STDOUT_FILENO);
	ft_putstr_fd("\n", STDOUT_FILENO);
	while (WAIT)
		;
	exit(EXIT_SUCCESS);
}

static void	ft_handler_action(int signal, siginfo_t *info, \
				__attribute__((unused))void *ucontext)
{
	static int	receive_bit;
	static char	chr;

	receive_bit++;
	if (signal == SIGUSR2)
		chr |= BIT;
	if (receive_bit == BYTE_SIZE)
	{
		write(STDOUT_FILENO, &chr, BIT);
		receive_bit = DEFAULT;
		chr = DEFAULT;
	}
	chr <<= BIT;
	if (kill(info->si_pid, SIGUSR1))
		exit(EXIT_FAILURE);
}

static void	ft_handle_msg_error(char *str)
{
	ft_putstr_fd(str, STDERR_FILENO);
	exit(EXIT_FAILURE);
}
