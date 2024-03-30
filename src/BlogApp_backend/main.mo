import Nat "mo:base/Nat";
import Time "mo:base/Time";
import D "mo:base/Debug";
import Int "mo:base/Int";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";


actor blog{
  type Comment = {
      author: Principal;
      content: Text;
      createdAt: Int;
  };
  type Post = {
    id: Nat;
    author: Principal;
    title: Text;
    content: Text;
    image: Text;
    createdAt: Int;
    updatedAt: Int;
    comments: [Comment];
    likes: Nat;
    liked: [Principal];
  };

  type PostPayload = {
    title: Text;
    content: Text;
    image: Text;
  };
 let PostSave = HashMap.HashMap<Nat, Post>(0, Nat.equal, Hash.hash);

 var postIdCount : Nat = 0;
 public query func getAllPost(): async [Post]{
    Iter.toArray(PostSave.vals());
 };

  public shared({caller}) func createPost(payload : PostPayload): async Nat{
    let currentTime= Time.now();
    var likes: Nat = 0;
    
    let newPost : Post = {
      id = postIdCount;
      author= caller;
      title= payload.title;
      content= payload.content;
      image= payload.image;
      createdAt= currentTime;
      updatedAt= currentTime;
      comments= [];
      likes= likes;
      liked= [];
    };
    PostSave.put(newPost.id, newPost);
    postIdCount := postIdCount + 1;
    postIdCount; 
    
  };
 public func getPostById(id: Nat):async ?Post{
   PostSave.get(id);
 };
 public shared({caller}) func updatePost(id:Nat , payload: PostPayload): async Text {

  let oldpost: ?Post = PostSave.get(id);
  
  switch(oldpost) {
    case(null) { 
      return "post doesnt exist"
    };
    case(?currentPost) {
      //checks if caller is valid
      assert(currentPost.author == caller);

      let updatedPost :Post = {
      id = id;
      author = currentPost.author;
      title= payload.title;
      content= payload.content;
      image= payload.image;
      createdAt= currentPost.createdAt;
      updatedAt= currentPost.updatedAt;
      comments= currentPost.comments;
      likes= currentPost.likes;
      liked= currentPost.liked;
  };
  PostSave.put(id, updatedPost);
  "post updated successfully";
     }; 
  };
 };
 public shared({caller}) func deletePost(id: Nat){
   let oldpost: ?Post = PostSave.get(id);

   switch(oldpost) {
     case(null) {  };
     case(?cuurent) { 
        assert(cuurent.author == caller);
        ignore PostSave.remove(id);
     };
   };
 };

 public shared({caller}) func like(id: Nat){
   let postRes: ?Post = PostSave.get(id);
   switch(postRes) {
     case(null) {  };
     case(?currentPost) {
      
      let updatedPost :Post = {
      id = id;
      author = currentPost.author;
      title= currentPost.title;
      content= currentPost.content;
      image= currentPost.image;
      createdAt= currentPost.createdAt;
      updatedAt= currentPost.updatedAt;
      comments= currentPost.comments;
      likes= currentPost.likes + 1;
      liked= [caller];
  };
  PostSave.put(id, updatedPost);
      };
   };
 }
  

  };
 

