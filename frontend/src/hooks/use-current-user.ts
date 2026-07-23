"use client";

import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCurrentUser, updateCurrentUser, type UpdateUserPayload } from "@/lib/services/users";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import { getApiErrorMessage, type ApiErrorResponse } from "@/lib/api-error";
import type { User } from "@/lib/services/users";
import { toast } from "@/lib/toast";

const CURRENT_USER_QUERY_KEY = ["current-user"];

export function useCurrentUser() {
  const [hasToken, setHasToken] = useState(false);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setHasToken(!!getAccessTokenFromCookie());
  }, []);

  return useQuery<User, ApiErrorResponse>({
    queryKey: CURRENT_USER_QUERY_KEY,
    queryFn: getCurrentUser,
    enabled: hasToken,
    retry: false,
  });
}

export function useUpdateCurrentUser() {
  const queryClient = useQueryClient();

  return useMutation<User, ApiErrorResponse, UpdateUserPayload>({
    mutationFn: updateCurrentUser,
    onSuccess: (user) => {
      queryClient.setQueryData(CURRENT_USER_QUERY_KEY, user);
      toast.success("Profilin güncellendi.");
    },
    onError: (err) => {
      toast.error(getApiErrorMessage(err));
    },
  });
}