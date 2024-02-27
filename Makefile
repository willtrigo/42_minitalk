# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dande-je <dande-je@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/02/26 02:18:15 by dande-je          #+#    #+#              #
#    Updated: 2024/02/27 05:43:41 by dande-je         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#******************************************************************************#
#                                REQUIREMENTS                                  #
#******************************************************************************#

LIBFT_VERSION                   := 2.4.8

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

SRCS_MAIN_DIR                   := src/
INCS                            := src/ lib/42_libft/include/
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

SRCS_SERVER_FILES               += $(addprefix $(SRCS_MAIN_DIR), server.c)
SRCS_CLIENT_FILES               += $(addprefix $(SRCS_MAIN_DIR), client.c)

OBJS_SERVER                     += $(SRCS_SERVER_FILES:%.c=$(BUILD_DIR)%.o)
OBJS_CLIENT                     += $(SRCS_CLIENT_FILES:%.c=$(BUILD_DIR)%.o)

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
COMP_MESSAGE                    = Building C object

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
	CFLAGS += $(DFLAGS)
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
	printf "$(RED)$(CLEAN_MESSAGE)\n$(RESET)"
endef

define fclean
	$(RM) $(NAME_SERVER) $(NAME_CLIENT)
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

all: | $(LIBFT) $(NAME_SERVER) $(NAME_CLIENT)

$(BUILD_DIR)%.o: %.c
	$(call create_dir)
	$(call comp_objs)

$(NAME_SERVER): $(call reset_count_server, $(words $(OBJS_SERVER))) $(OBJS_SERVER)
	$(call comp_exe_server)

$(NAME_CLIENT): $(NAME_SERVER) | $(call reset_count_client, -$(words $(OBJS_SERVER))) $(OBJS_CLIENT)
	$(call comp_exe_client)

$(LIBFT):
	$(call submodule_update_libft)

clean:
	$(call clean)

fclean: clean
	$(call fclean)

re: fclean all

debug:
	$(call debug)

.PHONY: all clean fclean re debug
.DEFAULT_GOAL := all
.SILENT:

-include $(DEPS)
