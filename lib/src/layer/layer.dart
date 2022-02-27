
import 'package:tastypie/src/taste/taste.dart';

abstract class ITastyPieLayer {
    void addTaste(ITaste taste);
    void removeTaste(ITaste taste);
    List<ITaste> getTasteInLayer();
    List<String> getTopicInLayer();
    void connectLayer(ITastyPieLayer layer);
    void disconnectLayer(ITastyPieLayer layer);

}