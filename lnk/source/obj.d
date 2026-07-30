import std.json;
import std.algorithm;
import std.conv;
import std.array;

enum RelocType {
    val,
    imm,
    uimm
}

struct Label {
    string name;
    long offset;
    string section;
    bool global;
    long address = 0;

    static Label fromJSON(JSONValue obj) {
        Label l;
        l.name = obj["name"].str;
        l.offset = obj["offset"].integer;
        l.section = obj["section"].str;
        l.global = obj["global"].type == JSONType.true_;
        return l;
    }
}

struct Relocation {
    long offset;
    string label;
    string section;
    RelocType relocType;

    static Relocation fromJSON(JSONValue obj) {
        Relocation r;
        r.offset = obj["offset"].integer;
        r.label = obj["label"].str;
        r.section = obj["section"].str;
        r.relocType = obj["relocType"].str.to!RelocType;
        return r;
    }
}

struct Constant {
    string name;
    long value;

    static Constant fromJSON(JSONValue obj) {
        Constant c;
        c.name = obj["name"].str;
        c.value = obj["value"].integer;
        return c;
    }
}

struct ObjFile {
    string segment;
    string text;
    string data;
    string bss;
    Label[] labels;
    Relocation[] relocations;
    Constant[] constants;
    long textAddress = 0;
    long dataAddress = 0;
    long bssAddress = 0;

    static ObjFile fromJSON(JSONValue obj) {
        ObjFile o;
        o.segment = obj["segment"].str;
        o.text = obj["text"].str;
        o.data = obj["data"].str;
        o.bss = obj["bss"].str;
        o.labels = obj["labels"].array.map!(a => Label.fromJSON(a)).array;
        o.relocations = obj["relocations"].array.map!(a => Relocation.fromJSON(a)).array;
        o.constants = obj["constants"].array.map!(a => Constant.fromJSON(a)).array;
        return o;
    }
}
