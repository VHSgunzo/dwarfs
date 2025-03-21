/* vim:set ts=2 sw=2 sts=2 et: */
/**
 * \author     Marcus Holland-Moritz (github@mhxnet.de)
 * \copyright  Copyright (c) Marcus Holland-Moritz
 *
 * This file is part of dwarfs.
 *
 * dwarfs is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * dwarfs is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with dwarfs.  If not, see <https://www.gnu.org/licenses/>.
 */

#pragma once

#include <functional>
#include <string>
#include <string_view>

#include <boost/program_options.hpp>

#include <dwarfs/config.h>

#ifdef DWARFS_BUILTIN_MANPAGE
#include <dwarfs/tool/manpage.h>
#endif

namespace dwarfs {

struct logger_options;
class library_dependencies;

namespace tool {

struct iolayer;

using extra_deps_fn = std::function<void(library_dependencies&)>;

std::string tool_header(std::string_view tool_name, std::string_view extra_info,
                        extra_deps_fn const& extra_deps);

std::string tool_header_nodeps(std::string_view tool_name);

inline std::string
tool_header(std::string_view tool_name, std::string_view extra_info = {}) {
  return tool_header(tool_name, extra_info, {});
}

inline std::string
tool_header(std::string_view tool_name, extra_deps_fn const& extra_deps) {
  return tool_header(tool_name, {}, extra_deps);
}

void add_common_options(boost::program_options::options_description& opts,
                        logger_options& logopts);

#ifdef DWARFS_BUILTIN_MANPAGE
void show_manpage(manpage::document doc, iolayer const& iol);
#endif

} // namespace tool

} // namespace dwarfs
