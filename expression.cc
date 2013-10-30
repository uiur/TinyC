#include "expression.h"
#include <string>
#include <sstream>
using namespace std;

NodeIdent::NodeIdent(string ident) {
    ident_ = ident;
}

NodeIdent::~NodeIdent() {}

void NodeIdent::print(ostream &os) {
    os << "(IDENT " << ident_ << ')';
}

NodeInteger::NodeInteger(int value) {
    value_ = value;
}

NodeInteger::~NodeInteger() {}

void NodeInteger::print(ostream &os) {
    os << '(' << value_ << ')';
}

NodeRelation::NodeRelation(int op, Node *left, Node *right) {
    op_ = op;
    left_ = left;
    right_ = right;
}

NodeRelation::~NodeRelation() {
    delete left_;
    delete right_;
}

void NodeRelation::print(ostream &os) {
    os << '(' << op_ << ' '; 
        left_->print(os);
        os << ' ';
        right_->print(os);
        os << ')';
}

NodeArithmeticOperation::NodeArithmeticOperation(int op, Node *left, Node *right) {
    op_ = op;
    left_ = left;
    right_ = right;
}

NodeArithmeticOperation::~NodeArithmeticOperation() {
    delete left_;
    delete right_;
}

void NodeArithmeticOperation::print(ostream &os) {
    os << '(' << op_ << ' '; 
        left_->print(os);
        os << ' ';
        right_->print(os);
        os << ')';
}

NodeMonoArithmeticOperation::NodeMonoArithmeticOperation(int op, Node *node) {
    op_ = op;
    node_ = node;
}

NodeMonoArithmeticOperation::~NodeMonoArithmeticOperation() {
    delete node_;
}

void NodeMonoArithmeticOperation::print(ostream &os) {
    os << '(' << op_ << ' ';
        node_->print(os);
        os << ')';
}

NodeAssign::NodeAssign(Node *identifier, Node *assign_value) {
    ident_ = identifier;
    assign_value_ = assign_value;
}

NodeAssign::~NodeAssign() {
    delete ident_;
    delete assign_value_;
}

void NodeAssign::print(ostream &os) {
    os << "(ASSIGN ";
    ident_->print(os);
    os << ' ';
    assign_value_->print(os);
    os << ')';
}

NodeList::NodeList(Node *node, Node *next) {
    node_ = node;
    next_ = next;
}

NodeList::~NodeList() {
    delete node_;
    delete next_;
}

void NodeList::print(ostream &os) {
    os << '('; 
        node_->print(os);
        os << ' ';
        next_->print(os);
        os << ')';
}

NodeDefineVariable::NodeDefineVariable(Node *ident) {
    ident_ = ident;
}

NodeDefineVariable::~NodeDefineVariable() {
    delete ident_;
}

void NodeDefineVariable::print(ostream &os) {
    os << "(DEFINE ";
        ident_->print(os);
        os << ")";
}

NodeFunction::NodeFunction(Node *ident, Node *params, Node *statement) {
    ident_ = ident;
    params_ = params;
    statement_ = statement;
}

NodeFunction::~NodeFunction() {
    delete ident_;
    delete params_;
    delete statement_;
}

void NodeFunction::print(ostream &os) {
    os << "(FUNCTION ";
        ident_->print(os);
        if (params_ != NULL) {
            os << ' ';
            params_->print(os);
        }
        if (statement_ != NULL) {
            os << ' ';
            statement_->print(os);
        }
        os << ")";
}

NodeIfBlock::NodeIfBlock(Node *condition, Node *true_statement, Node *false_statement) {
    condition_ = condition;
    true_statement_ = true_statement;
    false_statement_ = false_statement;
}

NodeIfBlock::~NodeIfBlock() {
    delete condition_;
    delete true_statement_;
    delete false_statement_;
}

void NodeIfBlock::print(ostream &os) {
    os << "(IF ";
        condition_->print(os);
        os << " ";
        true_statement_->print(os);
        if (false_statement_ != NULL) {
            os << " ";
            false_statement_->print(os);
        }
        os << ")";
}

NodeReturn::NodeReturn(Node *value) {
    value_ = value;
}

NodeReturn::~NodeReturn() {
    delete value_;
}

void NodeReturn::print(ostream &os) {
    os << "(RETURN ";
    value_->print(os);
    os << ")";
}

NodeWhileBlock::NodeWhileBlock(Node *condition, Node *statement) {
    condition_ = condition;
    statement_ = statement;
}

NodeWhileBlock::~NodeWhileBlock() {
    delete condition_;
    delete statement_;
}

void NodeWhileBlock::print(ostream &os) {
    os << "(WHILE ";
    condition_->print(os);
    os << " ";
    statement_->print(os);
    os << ")";
}

NodeCallFunction::NodeCallFunction(Node *ident, Node *argument) {
    ident_ = ident;
    argument_ = argument;
}

NodeCallFunction::~NodeCallFunction() {
    delete ident_;
    delete argument_;
}

void NodeCallFunction::print(ostream &os) {
    os << "(";
    ident_->print(os);
    os << " ";
    argument_->print(os);
    os << ")";
}