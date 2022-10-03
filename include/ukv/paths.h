/**
 * @file paths.h
 * @author Ashot Vardanian
 * @date 23 Sep 2022
 * @brief C bindings for paths ~ variable length string keys collections.
 *
 * It is a bad practice to use strings as key.
 */

#pragma once

#include "db.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief
 *
 */
void ukv_paths_write( //
    ukv_database_t const db,
    ukv_transaction_t const txn,
    ukv_size_t const tasks_count,

    ukv_collection_t const* collections,
    ukv_size_t const collections_stride,

    ukv_length_t const* paths_offsets,
    ukv_size_t const paths_offsets_stride,

    ukv_length_t const* paths_lengths,
    ukv_size_t const paths_lengths_stride,

    ukv_str_view_t const* paths,
    ukv_size_t const paths_stride,

    ukv_octet_t const* values_presences,

    ukv_length_t const* values_offsets,
    ukv_size_t const values_offsets_stride,

    ukv_length_t const* values_lengths,
    ukv_size_t const values_lengths_stride,

    ukv_bytes_cptr_t const* values_bytes,
    ukv_size_t const values_bytes_stride,

    ukv_options_t const options,
    ukv_char_t const separator,

    ukv_arena_t* arena,
    ukv_error_t* error);

/**
 */
void ukv_paths_read( //
    ukv_database_t const db,
    ukv_transaction_t const txn,
    ukv_size_t const tasks_count,

    ukv_collection_t const* collections,
    ukv_size_t const collections_stride,

    ukv_length_t const* paths_offsets,
    ukv_size_t const paths_offsets_stride,

    ukv_length_t const* paths_lengths,
    ukv_size_t const paths_lengths_stride,

    ukv_str_view_t const* paths,
    ukv_size_t const paths_stride,

    ukv_options_t const options,
    ukv_char_t const separator,

    ukv_octet_t** presences,
    ukv_length_t** offsets,
    ukv_length_t** lengths,
    ukv_byte_t** values,

    ukv_arena_t* arena,
    ukv_error_t* error);

/**
 */
void ukv_paths_match( //
    ukv_database_t const db,
    ukv_transaction_t const txn,
    ukv_size_t const tasks_count,

    ukv_collection_t const* collections,
    ukv_size_t const collections_stride,

    ukv_length_t const* regex_offsets,
    ukv_size_t const regex_offsets_stride,

    ukv_length_t const* regex_lengths,
    ukv_size_t const regex_lengths_stride,

    ukv_str_view_t const* regex_patterns,
    ukv_size_t const regex_patterns_stride,

    ukv_length_t const* previous_offsets,
    ukv_size_t const previous_offsets_stride,

    ukv_length_t const* previous_lengths,
    ukv_size_t const previous_lengths_stride,

    ukv_str_view_t const* previous_matches,
    ukv_size_t const previous_matches_stride,

    ukv_length_t const* match_counts_limits,
    ukv_size_t const match_counts_limits_stride,

    ukv_options_t const options,
    ukv_char_t const separator,

    ukv_length_t** match_counts_per_prefix,
    ukv_length_t** paths_offsets,
    ukv_char_t** paths_strings,

    ukv_arena_t* arena,
    ukv_error_t* error);

#ifdef __cplusplus
} /* end extern "C" */
#endif
