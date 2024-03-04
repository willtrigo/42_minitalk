/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_validation_bonus.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/03 23:59:07 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 19:47:11 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_stdlib.h"
#include "ft_client_bonus.h"
#include "ft_utils_bonus.h"

int	ft_check_arguments(int argc, char *pid)
{
	int	server_pid;

	if (argc != ARG_SIZE)
		ft_handle_msg_error("Invalid arguments.\n");
	server_pid = ft_atoi(pid);
	while (*pid)
		if (!ft_isdigit(*pid++))
			ft_handle_msg_error("Invalid PID.\n");
	return (server_pid);
}
