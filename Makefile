# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/02/26 02:18:15 by dande-je          #+#    #+#              #
#    Updated: 2024/03/13 03:09:26 by dande-je         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#******************************************************************************#
#                                REQUIREMENTS                                  #
#******************************************************************************#

LIBFT_VERSION                   := 3.0.0

#******************************************************************************#
#                                   COLOR                                      #
#******************************************************************************#

RED                             := \033[0;31m
GREEN                           := \033[0;32m
YELLOW                          := \033[0;33m
PURPLE                          := \033[0;35m
CYAN                            := \033[0;36m
RESET                           := \033[0m

#******************************************************************************#
#                                   PATH                                       #
#******************************************************************************#

SRCS_SERVER_DIR                 := src/src_server/
SRCS_CLIENT_DIR                 := src/src_client/
SRCS_SERVER_BONUS_DIR           := bonus/src_server/
SRCS_CLIENT_BONUS_DIR           := bonus/src_client/
INCS                            := src/src_server/ src/src_client/ bonus/src_server/ bonus/src_client lib/42_libft/include/
BUILD_DIR                       := build/
LIBFT_DIR                       := lib/42_libft/

#******************************************************************************#
#                                  COMMANDS                                    #
#******************************************************************************#

RM                              := rm -rf
MKDIR                           := mkdir -p
MAKEFLAGS                       += --no-print-directory
SLEEP                           := sleep 0.01

#******************************************************************************#
#                                   FILES                                      #
#******************************************************************************#

LIBFT = $(addprefix $(LIBFT_DIR), libft.a)
LIBS                            := ./lib/42_libft/libft.a

NAME_SERVER                     = server
NAME_CLIENT                     = client

NAME_SERVER_BONUS               = server_bonus
NAME_CLIENT_BONUS               = client_bonus

SRCS_SERVER_FILES               += $(addprefix $(SRCS_SERVER_DIR), ft_server.c)
SRCS_CLIENT_FILES               += $(addprefix $(SRCS_CLIENT_DIR), ft_client.c \
	ft_signal.c \
	ft_utils.c \
	ft_validation.c)

SRCS_SERVER_BONUS_FILES         += $(addprefix $(SRCS_SERVER_BONUS_DIR), ft_server_bonus.c)
SRCS_CLIENT_BONUS_FILES         += $(addprefix $(SRCS_CLIENT_BONUS_DIR), ft_client_bonus.c \
	ft_signal_bonus.c \
	ft_utils_bonus.c \
	ft_validation_bonus.c)

OBJS_SERVER                     += $(SRCS_SERVER_FILES:%.c=$(BUILD_DIR)%.o)
OBJS_CLIENT                     += $(SRCS_CLIENT_FILES:%.c=$(BUILD_DIR)%.o)

OBJS_SERVER_BONUS               += $(SRCS_SERVER_BONUS_FILES:%.c=$(BUILD_DIR)%.o)
OBJS_CLIENT_BONUS               += $(SRCS_CLIENT_BONUS_FILES:%.c=$(BUILD_DIR)%.o)

DEPS                            += $(OBJS_CLIENT:.o=.d)
DEPS                            += $(OBJS_SERVER:.o=.d)

#******************************************************************************#
#                               OUTPUTS MESSAGES                               #
#******************************************************************************#

COUNT                           = 0
OBJS_COUNT                      = 0
MATH                            = 0
CLEAN_MESSAGE                   := Server objects deleted\nClient objects deleted
FCLEAN_MESSAGE                  := Server deleted\nClient deleted
EXE_SERVER_MESSAGE              = $(RESET)[100%%] $(GREEN)Built target server
EXE_CLIENT_MESSAGE              = $(RESET)[100%%] $(GREEN)Built target client
EXE_SERVER_BONUS_MESSAGE        = [100%%] $(GREEN)Built target server_bonus
EXE_CLIENT_BONUS_MESSAGE        = [100%%] $(GREEN)Built target client_bonus
COMP_MESSAGE                    = Building C object
COMP_BONUS_MESSAGE              = $(CYAN)[BONUS]$(RESET) $(YELLOW)Building C object

#******************************************************************************#
#                               COMPILATION                                    #
#******************************************************************************#

CC                             := cc
CFLAGS                         = -Wall -Wextra -Werror -Ofast
CPPFLAGS                       := $(addprefix -I,$(INCS)) -MMD -MP
DFLAGS                         := -g3
LFLAGS                         := -march=native
LDFLAGS                        := $(addprefix -L,$(dir $(LIBS)))
LDLIBS                         := -lft -ldl
COMPILE_OBJS                   = $(CC) $(CFLAGS) $(LFLAGS) $(CPPFLAGS) -c $< -o $@
COMPILE_EXE_SERVER             = $(CC) $(LDFLAGS) $(OBJS_SERVER) $(LDLIBS) -o $(NAME_SERVER)
COMPILE_EXE_CLIENT             = $(CC) $(LDFLAGS) $(OBJS_CLIENT) $(LDLIBS) -o $(NAME_CLIENT)

#******************************************************************************#
#                                   DEFINE                                     #
#******************************************************************************#

ifdef WITH_DEBUG
	CFLAGS                     += $(DFLAGS)
endif

ifdef WITH_BONUS
	NAME_SERVER                = $(NAME_SERVER_BONUS)
	NAME_CLIENT                = $(NAME_CLIENT_BONUS)
	OBJS_SERVER                = $(OBJS_SERVER_BONUS)
	OBJS_SERVER                = $(OBJS_SERVER_BONUS)
	OBJS_CLIENT                = $(OBJS_CLIENT_BONUS)
	OBJS_CLIENT                = $(OBJS_CLIENT_BONUS)
	COMP_MESSAGE               = $(COMP_BONUS_MESSAGE)
	EXE_SERVER_MESSAGE         = $(EXE_SERVER_BONUS_MESSAGE)
	EXE_CLIENT_MESSAGE         = $(EXE_CLIENT_BONUS_MESSAGE)
endif

#******************************************************************************#
#                                  FUNCTION                                    #
#******************************************************************************#

define create_dir
	$(MKDIR) $(dir $@)
endef

define submodule_update_libft
	$(RM) $(LIBFT_DIR)
	printf "$(PURPLE)Building library Libft\n$(RESET)"
	git submodule update --init --recursive >/dev/null 2>&1 || true
	git submodule foreach -q --recursive \
		'branch="$(git config -f $toplevel/.gitmodules submodule.42_libft)"; \
		git pull origin main; \
		git fetch; \
		git checkout v$(LIBFT_VERSION)' \
		>/dev/null 2>&1 || true
	$(SLEEP)
	$(MAKE) -C $(LIBFT_DIR)
endef

define bonus
	$(MAKE) WITH_BONUS=TRUE
endef

define comp_objs
	$(eval COUNT=$(shell expr $(COUNT) + 1))
	$(COMPILE_OBJS)
	$(eval MATH=$(shell expr "$(COUNT)" \* 100 \/ "$(OBJS_COUNT)"))
	$(eval MATH=$(shell if [ $(COUNT) -lt 1 ]; then echo $(shell expr "$(MATH)" + 100) ; else echo $(MATH) ; fi))
	printf "[%3d%%] $(YELLOW)$(COMP_MESSAGE) $@ \r$(RESET)\n" $$(echo $(MATH))
endef

define comp_exe_server
	$(COMPILE_EXE_SERVER)
	$(SLEEP)
	printf "$(EXE_SERVER_MESSAGE)\n$(RESET)"
endef

define comp_exe_client
	$(COMPILE_EXE_CLIENT)
	$(SLEEP)
	printf "$(EXE_CLIENT_MESSAGE)\n$(RESET)"
endef

define clean
	$(RM) $(BUILD_DIR)
	$(MAKE) fclean -C $(LIBFT_DIR)
	$(SLEEP)
	printf "$(RED)$(CLEAN_MESSAGE)$(RESET)\n"
endef

define fclean
	$(RM) $(NAME_SERVER) $(NAME_CLIENT) $(NAME_SERVER_BONUS) $(NAME_CLIENT_BONUS)
	$(SLEEP)
	printf "$(RED)$(FCLEAN_MESSAGE)$(RESET)\n"
endef

define debug
	$(call clean)
	$(call fclean)
	$(MAKE) WITH_DEBUG=TRUE
endef

define reset_count_server
	$(eval COUNT=$(1))
	$(eval OBJS_COUNT=$(words $(SRCS_SERVER_FILES)))
endef

define reset_count_client
	$(eval COUNT=$(1))
	$(eval OBJS_COUNT=$(words $(SRCS_CLIENT_FILES)))
endef

#******************************************************************************#
#                                   TARGETS                                    #
#******************************************************************************#

all: $(NAME_SERVER) $(NAME_CLIENT)

$(BUILD_DIR)%.o: %.c
	$(call create_dir)
	$(call comp_objs)

$(NAME_SERVER): $(LIBFT) $(call reset_count_server, $(words $(OBJS_SERVER))) $(OBJS_SERVER)
	$(call comp_exe_server)

$(NAME_CLIENT): $(LIBFT) $(call reset_count_client, -$(words $(OBJS_SERVER))) $(OBJS_CLIENT)
	$(call comp_exe_client)

$(LIBFT):
	$(call submodule_update_libft)

bonus:
	$(call bonus)

clean:
	$(call clean)

fclean: clean
	$(call fclean)

re: fclean all

debug:
	$(call debug)

.PHONY: all clean fclean re debug bonus
.DEFAULT_GOAL := all
.SILENT:

-include $(DEPS)
