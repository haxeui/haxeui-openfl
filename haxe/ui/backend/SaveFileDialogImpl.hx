package haxe.ui.backend;

#if !js
import haxe.ui.containers.dialogs.Dialogs.FileDialogExtensionInfo;
import haxe.ui.containers.dialogs.Dialogs.SelectedFileInfo;
import openfl.events.Event;
import openfl.filesystem.File;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;
#end

class SaveFileDialogImpl extends SaveFileDialogBase {
    #if js
    
    private var _fileSaver:haxe.ui.util.html5.FileSaver = new haxe.ui.util.html5.FileSaver();
    
    public override function show() {
        if (fileInfo == null || (fileInfo.text == null && fileInfo.bytes == null)) {
            throw "Nothing to write";
        }
        
        if (fileInfo.text != null) {
            _fileSaver.saveText(fileInfo.name, fileInfo.text, onSaveResult);
        } else if (fileInfo.bytes != null) {
            _fileSaver.saveBinary(fileInfo.name, fileInfo.bytes, onSaveResult);
        }
    }
    
    private function onSaveResult(r:Bool) {
        if (r == true) {
            dialogConfirmed();
        } else {
            dialogCancelled();
        }
    }
    
    #else
    
    private var _file:File;
    
    public override function show() {
        var extensions = null;
        if (options != null) {
            extensions = options.extensions;
        }
        var data:Dynamic = null;
        var defaultFilename = null;
        if (fileInfo != null)  {
            defaultFilename = fileInfo.name;
            if (fileInfo.text != null) {
                data = fileInfo.text;   
            } else if (fileInfo.bytes != null) {
                data = ByteArray.fromBytes(fileInfo.bytes);
            }
        }

        _file = new File();
        _file.addEventListener(Event.SELECT, onSelect, false, 0, true);
        _file.addEventListener(Event.CANCEL, onCancel, false, 0, true);
        if (data != null) {
            _file.save(data, defaultFilename);
        } else {
            _file.browseForSave(options.title);
        }
    }
    
    private function buildFileFilters(extensions:Array<FileDialogExtensionInfo>):Array<FileFilter> {
        if (extensions == null) {
            return null;
        }

        var fileFilters:Array<FileFilter> = [];
        for (extension in extensions) {
            var extensionList = extension.extension.split(",");
            var fileFilterExtensions = "";
            for (extensionItem in extensionList) {
                extensionItem = extensionItem.trim();
                if (extensionItem.length == 0) {
                    continue;
                }

                fileFilterExtensions += "*." + extensionItem + ";";
            }
            if (fileFilterExtensions.length != 0) {
                fileFilters.push(new FileFilter(extension.label, fileFilterExtensions));
            }

        }
        return fileFilters;
    }

    private function onSelect(e:Event) {
        var selectedFileInfo:SelectedFileInfo = {
            name: _file.name,
            fullPath: _file.nativePath
        }
        destroyFileRef();
        dialogConfirmed(selectedFileInfo);
    }
    
    private function onCancel(e:Event) {
        destroyFileRef();
        dialogCancelled();
    }

    private function destroyFileRef() {
        if (_file == null) {
            return;
        }
        
        _file.removeEventListener(Event.SELECT, onSelect);
        _file.removeEventListener(Event.CANCEL, onCancel);
        _file = null;
    }
    
    #end
}
