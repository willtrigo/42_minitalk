/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_utils.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/04 00:08:59 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 19:50:26 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include "ft_non_standard/ft_non_standard.h"
#include "ft_client.h"
#include "ft_signal.h"

static void	ft_msg_head(int server_pid);
static void	ft_msg_body(int server_pid, char *msg);

void	ft_handle_msg_error(char *str)
{
	ft_putstr_fd("\033[0;31mError\033[0m - ", STDERR_FILENO);
	ft_putstr_fd(str, STDERR_FILENO);
	exit(EXIT_FAILURE);
}

void	ft_handle_msg(int server_pid, char *msg)
{
	ft_msg_head(server_pid);
	ft_msg_body(server_pid, msg);
}

static void	ft_msg_head(int server_pid)
{
	int		i;
	char	*header;
	char	*str_pid;

	i = I_DEFAULT;
	str_pid = ft_itoa(getpid());
	header = ft_strjoin("\033[0;33mFrom client PID: \033[0;36m", str_pid);
	while (header[++i])
		ft_send_signal(server_pid, header[i]);
	free(str_pid);
	free(header);
	ft_send_signal(server_pid, '\n');
}

static void	ft_msg_body(int server_pid, char *msg)
{
	int		i;
	char	*body;

	i = I_DEFAULT;
	body = ft_strjoin("\033[0;32m", msg);
	while (body[++i])
		ft_send_signal(server_pid, body[i]);
	free(body);
	ft_send_signal(server_pid, '\n');
}
