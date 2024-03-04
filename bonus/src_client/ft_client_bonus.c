/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_client_bonus.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:31 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 19:48:04 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <unistd.h>
#include "ft_client_bonus.h"
#include "ft_signal_bonus.h"
#include "ft_validation_bonus.h"

int	main(int argc, char **argv)
{
	int					server_pid;

	server_pid = ft_check_arguments(argc, argv[PID]);
	ft_signal(server_pid, argv[MSG]);
	exit(EXIT_SUCCESS);
}
