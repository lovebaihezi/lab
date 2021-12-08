#include <algorithm>
#include <array>
#include <cmath>
#include <concepts>
#include <deque>
#include <fmt/core.h>
#include <functional>
#include <glog/logging.h>
#include <iostream>
#include <map>
#include <memory>
#include <optional>
#include <queue>
#include <range/v3/action.hpp>
#include <range/v3/algorithm.hpp>
#include <range/v3/all.hpp>
#include <range/v3/core.hpp>
#include <range/v3/iterator.hpp>
#include <range/v3/utility.hpp>
#include <range/v3/view.hpp>
#include <range/v3/view_adaptor.hpp>
#include <set>
#include <stack>
#include <string>
#include <string_view>
#include <thread>
#include <type_traits>
#include <typeinfo>
#include <unordered_map>
#include <utility>
#include <vector>
using namespace ranges::views;
template <typename value>
auto ent(const auto &data_set, const std::size_t attribute, const std::size_t standard, auto indexes)
{
    std::unordered_map<value, std::unordered_map<value, std::size_t>> map{};
    std::unordered_map<value, std::size_t> count{};
    for (const auto index : indexes)
    {
        map[data_set[index][attribute]][data_set[index][standard]] += 1;
        count[data_set[index][attribute]] += 1;
    }
    std::vector<std::pair<std::pair<value, bool>, std::pair<std::size_t, double>>> result{};
    result.reserve(count.size());
    for (const auto &[key, maps] : map)
    {
        double x = 0;
        for (const auto &[_keys, val] : maps)
        {
            x += val * 1.0 / count[key] * 1.0 * std::log2(val * 1.0 / count[key] * 1.0);
        }
        result.push_back({{key, maps.size() == 1}, {count[key], x == 0.0 ? 0.0 : -x}});
    }
    /* for (const auto &[x, v] : result) { */
    /*   fmt::print("{} {} {} {}\n", x.first, x.second, v.first, v.second); */
    /* } */
    return result;
}

template <typename value>
std::vector<std::pair<std::pair<value, double>, std::vector<std::pair<value, bool>>>> gain(
    const auto &data_set, std::unordered_map<value, std::size_t> &attributes, const std::size_t standard, auto indexes)
{
    std::size_t len = indexes.size();
    std::unordered_map<value, std::size_t> d{};
    for (const auto i : indexes)
    {
        d[data_set[i][standard]] += 1;
    }
    double y = 0;
    for (const auto &[key, val] : d)
        y += val * 1.0 / len * 1.0 * std::log2(val * 1.0 / len * 1.0);
    y = -y;
    std::vector<std::pair<std::pair<value, double>, std::vector<std::pair<value, bool>>>> ents{};
    ents.reserve(attributes.size());
    for (const auto &[attribute, index] : attributes)
    {
        const auto vec = ent<value>(data_set, index, standard, indexes);
        std::vector<std::pair<value, bool>> v{};
        v.reserve(vec.size());
        double x{0.0};
        for (const auto &[key, pair] : vec)
        {
            v.push_back(key);
            auto &&[count, e] = pair;
            x += count * 1.0 / len * 1.0 * e;
        }
        ents.push_back({{attribute, y - x}, v});
    }
    return ents;
}

template <typename value> struct TreeNode
{
    value val{};
    std::unordered_map<value, TreeNode<value> *> *children{nullptr};
    TreeNode(value val) : val{val}
    {
    }
    TreeNode(std::vector<std::vector<value>> &data_set, std::unordered_map<value, std::size_t> &attributes,
             const std::size_t standard, std::vector<size_t> indexes)
    {
        if (indexes.size() == 0 || attributes.size() == 0)
        {
            return;
        }
        auto &&vec = gain(data_set, attributes, standard, indexes);
        auto [item, v] =
            *std::max_element(vec.begin(), vec.end(), [](auto a, auto b) { return a.first.second < b.first.second; });
        fmt::print("{} {} index: {}\n", item.first, item.second, attributes[item.first]);
        if (item.second == 0)
        {
            return;
        }
        val = item.first;
        std::size_t index = attributes[item.first];
        auto map = new std::unordered_map<value, TreeNode<value> *>{};
        attributes.erase(item.first);
        for (auto &[i, flag] : v)
        {
            fmt::print("{} {}\n", i, flag);
            if (flag)
            {
                map->insert({i, new TreeNode(i)});
            }
            else
            {
                std::vector<std::size_t> new_index{};
                new_index.reserve(data_set.size());
                for (auto a : indexes)
                {
                    if (data_set[a][index] == i)
                    {
                        new_index.push_back(a);
                    }
                }
                std::cout << "new indexes: [";
                for (auto i : new_index)
                {
                    fmt::print("{} ", i);
                }
                std::cout << ']' << std::endl;
                std::cout << "new attributes: {";
                for (auto [k, v] : attributes)
                {
                    fmt::print(" {} => {} ", k, v);
                }
                std::cout << "  }" << std::endl;
                if (attributes.size() != 0 && new_index.size() != 0)
                {
                    map->insert({i, new TreeNode(data_set, attributes, standard, new_index)});
                }
            }
        }
        children = map;
    }
    ~TreeNode()
    {
        if (this->children)
        {
            for (const auto &[key, v] : *(this->children))
                if (v != nullptr)
                    delete v;

            delete this->children;
        }
    }
    auto operator[](value index)
    {
        return this->children[index];
    }
    const auto operator[](value index) const
    {
        return this->children[index];
    }
};

template <typename value> struct Tree
{
    TreeNode<value> *root{nullptr};
    Tree(auto &data_set, std::unordered_map<value, std::size_t> &&attributes, const std::size_t standard)
    {
        std::vector<std::size_t> indexes{};
        indexes.reserve(data_set.size());
        for (std::size_t i = 0; i < data_set.size(); i += 1)
            indexes.push_back(i);
        root = new TreeNode<value>(data_set, attributes, standard, indexes);
    }
    Tree(Tree &x) = delete;
    Tree(Tree &&x) = default;
    ~Tree()
    {
        if (root)
        {
            delete root;
        }
    }
};

int main()
{
    using map = std::unordered_map<std::string_view, std::size_t>;
    using matrix = std::vector<std::vector<std::string_view>>;
    map maps{{"outlook", 0}, {"temperate", 1}, {"humidity", 2}, {"wind", 3}, {"play tennis", 4}};
    matrix data{{"Sunny", "Hot", "High", "Weak", "No"},
                {"Sunny", "Hot", "High", "Strong", "No"},
                {"Overcast", "Hot", "High", "Weak", "Yes"},
                {"Rain", "Mild", "High", "Weak", "Yes"},
                {"Rain", "Cool", "Normal", "Strong", "No"},
                {"Rain", "Cool", "Normal", "Strong", "Yes"},
                {"Overcast", "Cool", "Normal", "Strong", "Yes"},
                {
                    "Sunny",
                    "Mild",
                    "High",
                    "Weak",
                    "No",
                },
                {"Sunny", "Cool", "Normal", "Weak", "Yes"},
                {"Rain", "Mild", "Normal", "Weak", "Yes"},
                {"Sunny", "Mild", "Normal", "Strong", "Yes"},
                {"Overcast", "Mild", "High", "Strong", "Yes"},
                {"Overcast", "Hot", "Normal", "Weak", "Yes"},
                {"Rain", "Mild", "High", "Strong", "No"}};
    auto tree = Tree<std::string_view>(data,
                                       {
                                           {"outlook", 0},
                                           {"temperate", 1},
                                           {"humidity", 2},
                                           {"wind", 3},
                                       },
                                       4);
    std::queue<TreeNode<std::string_view> *> que{};
    que.push(tree.root);
    while (!que.empty())
    {
        auto front = que.front();
        que.pop();
        if (front)
        {

            if (front->children)
            {
                fmt::print("--{}--\n", front->val);
                for (const auto [attr, node] : *(front->children))
                {
                    fmt::print(" <{}> ", attr);
                    que.push(node);
                }
                fmt::print("\n|>===<|\n");
            }
            else
            {
                fmt::print("\\\\{}//\n", front->val);
            }
        }
    }
    return 0;
}
