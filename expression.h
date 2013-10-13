#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <string>
#include <sstream>
using namespace std;

class Node {
public:
    virtual void print(ostream &os) = 0;
};

class NodeIdent : public Node {
    string ident_;
public:
    explicit NodeIdent(string ident);
    virtual ~NodeIdent();
    void print(ostream &os);
};

class NodeInteger : public Node {
    int value_;
public:
    explicit NodeInteger(int value);
    virtual ~NodeInteger();
    void print(ostream &os);
};

class NodeRelation : public Node {
    int op_;
    Node *left_;
    Node *right_;
public:
    explicit NodeRelation(int op, Node *left, Node *right);
    ~NodeRelation();
    void print(ostream &os);
};

class NodeArithmeticOperation : public Node {
    int op_;
    Node *left_;
    Node *right_;
public:
    explicit NodeArithmeticOperation(int op, Node *left, Node *right);
    ~NodeArithmeticOperation();
    void print(ostream &os);
};

class NodeMonoArithmeticOperation : public Node {
    int op_;
    Node *node_;
public:
    explicit NodeMonoArithmeticOperation(int op, Node *node);
    ~NodeMonoArithmeticOperation();
    void print(ostream &os);
};

class NodeAssign : public Node {
    Node *ident_;
    Node *assign_value_;
public:
    explicit NodeAssign(Node *identifier, Node *assign_value); 
    ~NodeAssign();
    void print(ostream &os);   
};

class NodeList : public Node {
    Node *node_;
    Node *next_;
public:
    explicit NodeList(Node *node, Node *next);
    ~NodeList();
    void print(ostream &os);
};

class NodeDefineVariable : public Node {
    Node *ident_;
public:
    explicit NodeDefineVariable(Node *ident);
    ~NodeDefineVariable();
    void print(ostream &os);
};

class NodeFunction : public Node {
    Node *ident_;
    Node *params_;
    Node *statement_;
public:
    explicit NodeFunction(Node *ident, Node *params, Node *statement);
    ~NodeFunction();
    void print(ostream &os);
};

class NodeIfBlock : public Node {
    Node *condition_;
    Node *true_statement_;
    Node *false_statement_;
public:
    explicit NodeIfBlock(Node *condition, Node *true_statement, Node *false_statement);
    ~NodeIfBlock();

    void print(ostream &os);
};

class NodeReturn : public Node {
    Node *value_;
public:
    explicit NodeReturn(Node *value);
    ~NodeReturn();

    void print(ostream &os);
};

class NodeWhileBlock : public Node {
    Node *condition_;
    Node *statement_;
public:
    explicit NodeWhileBlock(Node *condition, Node *statement);
    ~NodeWhileBlock();

    void print(ostream &os);
};

#endif