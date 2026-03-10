pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Core

Singleton {
    id: root

    FileView {
        id: fileView
        path: `${Paths.data}/preferences.json`
        watchChanges: true
        onFileChanged: reload()

        readonly property var json: {
            const text = this.text();
            if (text.length > 0) {
                try {
                    return JSON.parse(text);
                } catch (e) {
                    console.error(e);
                    return {};
                }
            }
        }

        function set(key: string, value: var): void {
            json[key] = value;
            setText(JSON.stringify(json));
        }
    }

    function remove(key: string): void {
        delete fileView.json[key];
    }

    function has(key: string): bool {
        return key in fileView.json;
    }

    function setInt(key: string, value: int): void {
        fileView.set(key, value);
    }

    function setDouble(key: string, value: double): void {
        fileView.set(key, value);
    }

    function setReal(key: string, value: real): void {
        fileView.set(key, value);
    }

    function setString(key: string, value: string): void {
        fileView.set(key, value);
    }

    function setStringList(key: string, value: list<string>): void {
        fileView.set(key, value);
    }

    function setIntList(key: string, value: list<bool>): void {
        fileView.set(key, value);
    }

    function setIntList(key: string, value: list<int>): void {
        fileView.set(key, value);
    }

    function setDoubleList(key: string, value: list<double>): void {
        fileView.set(key, value);
    }

    function setRealList(key: string, value: list<real>): void {
        fileView.set(key, value);
    }

    function getBool(key: string, defaultValue: bool): bool {
        const value = fileView.json[key];
        if (value == undefined || value == null)
            return defaultValue;

        if (typeof value === "bool") {
            return value;
        }

        __incompatibleType(value, "bool");
    }

    function getInt(key: string, defaultValue: int): int {
        const value = fileView.json[key];
        if (value === undefined || value === null)
            return defaultValue;

        if (typeof value === "number" && Number.isInteger(value)) {
            return value;
        }

        __incompatibleType(value, "int");
    }

    function getDouble(key: string, defaultValue: double): double {
        return __getDoubleOrReal(key, defaultValue, "double");
    }

    function getReal(key: string, defaultValue: real): real {
        return __getDoubleOrReal(key, defaultValue, "real");
    }

    function __getDoubleOrReal(key: string, defaultValue: var, expected: string): var {
        const value = fileView.json[key];
        if (value === undefined || value === null)
            return defaultValue;

        if (typeof value === "number" && !Number.isInteger(value)) {
            return value;
        }

        __incompatibleType(value, expected);
    }

    function getString(key: string, defaultValue: string): string {
        const value = fileView.json[key];

        if (value === undefined || value === null)
            return defaultValue;

        if (typeof value == "string") {
            return value;
        }

        __incompatibleType(value, "string");
    }

    function getBoolList(key: string, defaultValue: list<int>): list<bool> {
        return getList(key, defaultValue, e => typeof e == "number" && Number.isInteger(e), "list<bool>");
    }

    function getIntList(key: string, defaultValue: list<int>): list<int> {
        return getList(key, defaultValue, e => typeof e == "number" && Number.isInteger(e), "list<int>");
    }

    function getDoubleList(key: string, defaultValue: list<int>): list<int> {
        return getList(key, defaultValue, e => typeof e == "number" && !Number.isInteger(e), "list<double>");
    }

    function getRealList(key: string, defaultValue: list<int>): list<int> {
        return getList(key, defaultValue, e => typeof e == "number" && !Number.isInteger(e), "list<real>");
    }

    function getStringList(key: string, defaultValue: list<string>): list<string> {
        return getList(key, defaultValue, e => typeof e == "string", "list<string>");
    }

    function getList(key: string, defaultValue: list<var>, check: var, expected: string): list<var> {
        const value = fileView.json[key];
        if (value === undefined || value === null)
            return defaultValue;

        if (Array.isArray(value) && value.every(check)) {
            return value;
        }

        __incompatibleType(value, expected);
    }

    function __incompatibleType(value, expected) {
        throw new Error(`Incompatible type: "${typeof value}"; expected "${expected}"`);
    }
}
