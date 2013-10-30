#ifndef PARSER_H
#define PARSER_H

#include <vector>
#include <map>
#include <string>

namespace tinc {
    class Scope;
    class Identifier;
    class Parser;

    class Identifier {
    public:
        enum IdentifierType {
            VARIABLE,
            FUNCTION,
            PARAMETER,
            UNDEFINED_FUNCTION
        };

        explicit Identifier(std::string name, IdentifierType type, Scope *scope);
        ~Identifier();

        std::string name_;
        enum IdentifierType type_;
        Scope *scope_;
    };

    class Scope {
        std::map <std::string, Identifier *> identifier_list_;
    public:
        explicit Scope(Scope *parent);
        ~Scope();

        int level_;
        Scope *parent_;
        Identifier *add_identifier_by_name_and_type(const std::string name, const Identifier::IdentifierType type);
        Identifier *find_identifier_by_name(const std::string name);
        void print_identifiers();
    };

    class Parser {
    public:
        explicit Parser();
        ~Parser();

        Scope *global_scope_;
        Scope *current_scope_;

        void push_scope();
        void pop_scope();

        Identifier *register_identifier(std::string name, Identifier::IdentifierType);
        Identifier *find_identifier(std::string name);
        bool find_and_check_identifier_of_variable_declaration(const std::string name);
        bool find_and_check_identifier_of_function_declaration(const std::string name);
        bool find_and_check_identifier_of_variable_reference(const std::string name);
        bool find_and_check_identifier_of_function_reference(const std::string name);
    };
}

#endif