/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_client.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 02:14:31 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/15 06:14:55 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include "ft_client.h"
#include "ft_validation.h"
#include "ft_signal.h"

int	main(int argc, char **argv)
{
	int	server_pid;

	server_pid = ft_check_arguments(argc, argv[PID]);
	ft_signal(server_pid, argv[MSG]);
	exit(EXIT_SUCCESS);
}
