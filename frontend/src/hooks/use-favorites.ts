"use client";

import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { listFavorites, addFavorite, removeFavorite, type Favorite } from "@/lib/services/favorites";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import { getApiErrorMessage, type ApiErrorResponse } from "@/lib/api-error";
import { toast } from "@/lib/toast";

export const FAVORITES_QUERY_KEY = ["favorites"];

export function useFavorites() {
  const [hasToken, setHasToken] = useState(false);

  useEffect(() => {
    setHasToken(!!getAccessTokenFromCookie());
  }, []);

  return useQuery<Favorite[], ApiErrorResponse>({
    queryKey: FAVORITES_QUERY_KEY,
    queryFn: listFavorites,
    enabled: hasToken,
    retry: false,
  });
}

export function useAddFavorite() {
  const queryClient = useQueryClient();
  return useMutation<Favorite, ApiErrorResponse, string>({
    mutationFn: addFavorite,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: FAVORITES_QUERY_KEY });
      toast.success("Favorilere eklendi.");
    },
    onError: (err) => toast.error(getApiErrorMessage(err)),
  });
}

export function useRemoveFavorite() {
  const queryClient = useQueryClient();
  return useMutation<void, ApiErrorResponse, string>({
    mutationFn: removeFavorite,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: FAVORITES_QUERY_KEY });
      toast.success("Favorilerden çıkarıldı.");
    },
    onError: (err) => toast.error(getApiErrorMessage(err)),
  });
}