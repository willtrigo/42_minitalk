/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_client.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/26 04:05:29 by dande-je          #+#    #+#             */
/*   Updated: 2024/03/04 02:32:08 by dande-je         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FT_CLIENT_H
# define FT_CLIENT_H

enum e_client_default
{
	DEFAULT = 0,
	CLIENT_FAIL = -1,
	WAIT = 1,
	MSG = 2,
	I_DEFAULT = -1,
};

enum e_validation
{
	ARG_SIZE = 3,
	PID = 1,
};

enum e_handshake
{
	SET = 1,
	GET = -1,
};

enum e_signal
{
	BIT = 1,
	BYTE_SIZE = 8,
	SIGNAL_ON = 1,
	SIGNAL_OFF = 0,
};

#endif
