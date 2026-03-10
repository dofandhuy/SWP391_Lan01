
package Entity;


public class Relationship {
    private int relationshipID;
    private String relationshipName;


    // Constructor, Getters and Setters
    public Relationship() {}

    public Relationship(int relationshipID, String relationshipName) {
        this.relationshipID = relationshipID;
        this.relationshipName = relationshipName;
 
    }

    @Override
    public String toString() {
        return "Relationship{" + "relationshipID=" + relationshipID + ", relationshipName=" + relationshipName + '}';
    }

    // Getters
    public int getRelationshipID() { return relationshipID; }
    public String getRelationshipName() { return relationshipName; }


    // Setters
    public void setRelationshipID(int relationshipID) { this.relationshipID = relationshipID; }
    public void setRelationshipName(String relationshipName) { this.relationshipName = relationshipName; }

}

