/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_client.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:31 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 01:26:15 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <unistd.h>
#include "ft_client.h"
#include "ft_signal.h"
#include "ft_validation.h"

int	main(int argc, char **argv)
{
	int					server_pid;

	server_pid = ft_check_arguments(argc, argv[PID]);
	ft_signal(server_pid, argv[MSG]);
	exit(EXIT_SUCCESS);
}
