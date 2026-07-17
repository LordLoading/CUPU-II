import std.json;
import std.algorithm;
import std.conv;
import std.array;

enum RelocType
{
    inst,
    data,
    bss,
}

struct Label
{
    string name;
    long offset;
    string section;
    bool global;

    static Label fromJSON(JSONValue obj)
    {
        Label l;
        l.name = obj["name"].str;
        l.offset = obj["offset"].integer;
        l.section = obj["section"].str;
        l.global = obj["global"].type == JSONType.true_;
        return l;
    }
}

struct Relocation
{
    long offset;
    string label;
    string section;
    RelocType relocType;

    static Relocation fromJSON(JSONValue obj)
    {
        Relocation r;
        r.offset = obj["offset"].integer;
        r.label = obj["label"].str;
        r.section = obj["section"].str;
        r.relocType = obj["relocType"].str.to!RelocType;
        return r;
    }
}

struct ObjFile
{
    string fileName;
    string segment;
    string text;
    string data;
    string bss;
    Label[] labels;
    Relocation[] relocations;

    static ObjFile fromJSON(JSONValue obj)
    {
        ObjFile o;
        o.fileName = obj["fileName"].str;
        o.segment = obj["segment"].str;
        o.text = obj["text"]["items"].str;
        o.data = obj["data"]["items"].str;
        o.bss = obj["bss"]["items"].str;
        o.labels = obj["labels"]["items"].array.map!(a => Label.fromJSON(a)).array;
        o.relocations = obj["relocations"]["items"].array.map!(a => Relocation.fromJSON(a)).array;
        return o;
    }
}
