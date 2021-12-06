template<typename Value>
struct TreeNode {
    Value value;
    TreeNode* left;
    TreeNode* right;
    TreeNode(Value value, TreeNode* left = nullptr, TreeNode* right = nullptr): value{value},left {left}, right {right} {}
};

template<typename Value>
class AvlTree {
    TreeNode<Value>* root{ nullptr };
};

int main(int argc, char* args[]) {
    auto&& name = args[0];
    return 0;
}
