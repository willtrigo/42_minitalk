/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:37 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/01 07:05:53 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "server.h"

static void	ft_handler_action(int signal, siginfo_t *info, \
				__attribute__((unused))void *context);
static void	ft_handle_msg_error(char *str);

int	main(void)
{
	struct sigaction	server_action;

	ft_memset(&server_action, 0, sizeof(server_action));
	server_action.sa_sigaction = ft_handler_action;
	server_action.sa_flags = SA_SIGINFO;
	if (sigaction(SIGUSR1, &server_action, NULL) == FAIL_ \
		|| sigaction(SIGUSR2, &server_action, NULL) == FAIL_)
		ft_handle_msg_error("\033[0;31mError - Server signal fail.\n");
	ft_putstr_fd("\033[0;35mServer PID: \033[0;32m", STDOUT_FILENO);
	ft_putnbr_fd(getpid(), STDOUT_FILENO);
	ft_putstr_fd("\n\n", STDOUT_FILENO);
	while (WAIT)
		pause();
	exit(EXIT_SUCCESS);
}

static void	ft_handler_action(int signal, siginfo_t *info, \
			__attribute__((unused)) void *ucontext)
{
	static unsigned char	chr;
	static unsigned int		bits;

	bits++;
	if (signal == SIGUSR2)
		chr |= 1;
	if (bits == 8)
	{
		ft_putstr_fd((char *)&chr, STDOUT_FILENO);
		bits = 0;
		chr = 0;
	}
	chr <<= 1;
	if (kill(info->si_pid, SIGUSR1))
		exit(EXIT_FAILURE);
}

static void	ft_handle_msg_error(char *str)
{
	ft_putstr_fd(str, STDERR_FILENO);
	exit(EXIT_FAILURE);
}
