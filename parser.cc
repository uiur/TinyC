#include "parser.h"
#include <iostream>
#include <sstream>
#include <cstddef>
#include <string>
#include <map>

namespace tinc {
    Identifier::Identifier(std::string name, Identifier::IdentifierType type, Scope *scope) {
        name_ = name;
        type_ = type;
        scope_ = scope;
    }
    Identifier::~Identifier() {}

    Scope::Scope(Scope *parent) {
        // global scope
        if (parent == NULL) {
            level_ = 0;
        } else {
            parent_ = parent;
            level_ = parent->level_ + 1;
        }

    }
    Scope::~Scope() {}
    void Scope::print_identifiers() {
        std::cout << "Scope level: " << level_ << std::endl;

        if (identifier_list_.empty()) {
            return;
        }

        std::map<std::string, Identifier *>::iterator iterator;
        for (iterator = identifier_list_.begin(); iterator != identifier_list_.end(); ++iterator) {
            Identifier *identifier = iterator->second;
            std::cout << identifier->name_ <<  std::endl;
        }
    }

    Identifier* Scope::add_identifier_by_name_and_type(std::string name, Identifier::IdentifierType type) {
        Identifier *identifier = new Identifier(name, type, this);

        identifier_list_[name] = identifier;

        return identifier;
    }
    Identifier* Scope::find_identifier_by_name(std::string name) {
        if (identifier_list_.find(name) != identifier_list_.end()) {
            return identifier_list_[name];
        } else {
            if (parent_ == NULL) {
                return NULL;
            }

            return parent_->find_identifier_by_name(name);
        }
    }

    Parser::Parser(int *yylineno) {
        yylineno_ = yylineno;
        error_count_ = 0;
        global_scope_ = new Scope(NULL);
        current_scope_ = global_scope_;
    }

    Parser::~Parser() {
        delete global_scope_;
    }

    void Parser::push_scope() {
        Scope *scope = new Scope(current_scope_);
        current_scope_ = scope;
    }

    void Parser::pop_scope() {
        Scope *poped_scope = current_scope_;

        current_scope_ = current_scope_->parent_;
        delete poped_scope;
    }

    Identifier *Parser::register_identifier(const std::string name, const Identifier::IdentifierType type) {
        return current_scope_->add_identifier_by_name_and_type(name, type);
    }

    Identifier *Parser::find_identifier(const std::string name) {
        return current_scope_->find_identifier_by_name(name);
    }

    bool Parser::find_and_check_identifier_of_variable_declaration(const std::string name) {
        std::ostringstream oss;

        Identifier *identifier = this->find_identifier(name);

        if (identifier == NULL) {
            return true;
        }

        switch (identifier->type_) {
            case Identifier::VARIABLE:
                if (current_scope_->level_ == identifier->scope_->level_) {
                    oss << "Redeclaration of '" << name << "'";
                    print_error(oss.str());
                    error_count_++;

                    return false;
                }

                break;
            case Identifier::FUNCTION:
            case Identifier::UNDEFINED_FUNCTION:
                if (current_scope_->level_ == identifier->scope_->level_) {
                    oss << "'" << name << "'" << "redeclared as different kind of symbol";
                    print_error(oss.str());
                    error_count_++;

                    return false;
                }
                break;
            default:
                break;
        }

        return true;
    }

    bool Parser::find_and_check_identifier_of_function_declaration(const std::string name) {
        std::ostringstream oss;

        Identifier *identifier = this->find_identifier(name);

        if (identifier == NULL) {
            return true;
        }

        switch (identifier->type_) {
            case Identifier::VARIABLE:
                oss << "'" << name << "'" << "redeclared as different kind of symbol";
                print_error(oss.str());
                error_count_++;

                return false;
            case Identifier::FUNCTION:
                oss << "Redeclaration of '" << name << "'";
                print_error(oss.str());
                error_count_++;

                return false;
        }

        return true;
    }

    bool Parser::find_and_check_identifier_of_variable_reference(const std::string name) {
        std::ostringstream oss;

        Identifier *identifier = this->find_identifier(name);

        if (identifier == NULL) {
            oss << "'" << name << "' undeclared variable";
            print_error(oss.str());
            error_count_++;

            return false;
        }

        switch (identifier->type_) {
            case Identifier::FUNCTION:
                oss << "Redeclaration of '" << name << "'";
                print_error(oss.str());
                error_count_++;

                return false;
            case Identifier::UNDEFINED_FUNCTION:
                oss << "function '" << name << "' is used as variable";
                print_error(oss.str());
                error_count_++;

                return false;
        }

        return true;
    }

    bool Parser::find_and_check_identifier_of_function_reference(const std::string name) {
        std::ostringstream oss;

        Identifier *identifier = this->find_identifier(name);

        if (identifier == NULL) {
            oss << "'" << name << "' undeclared function";
            print_error(oss.str());
            error_count_++;

            return false;
        }

        switch (identifier->type_) {
            case Identifier::VARIABLE:
            case Identifier::PARAMETER:
                oss << "variable '" << name << "' is used as function";
                print_error(oss.str());
                error_count_++;

                return false;
        }

        return true;
    }

    void Parser::print_error(const std::string message) {
        std::cerr << *yylineno_ << ": " << "error" << ": " << message << std::endl;
    }

    bool Parser::is_no_error() {
        return (error_count_ == 0) ? true : false;
    }
}
